const { expect } = require("chai");
const { ethers } = require("hardhat");



describe("NFTMarketplace", function () {
  let NFTMarketplace, nftMarketplace, owner, addr1, addr2, MockERC721, mockERC721;

  beforeEach(async function () {
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();


    NFT = await ethers.getContractFactory("MockERC721");
    nft = await NFT.deploy();
    await nft.deployed();
    // MockERC721 = await ethers.getContractFactory("MockERC721");
    // mockERC721 = await MockERC721.deploy();
    // await mockERC721.deployed();

    NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
    nftMarketplace = await NFTMarketplace.deploy();
    await nftMarketplace.deployed();
  });

  it("Should start an NFT sale", async function () {
    await mockERC721.connect(owner).mint(addr1.address, 1);
    await mockERC721.connect(addr1).approve(nftMarketplace.address, 1);

    await nftMarketplace.connect(addr1).startNFTSale(mockERC721.address, ethers.utils.parseEther("1"), 1);

    const item = await nftMarketplace.idToItemForSale(0);
    expect(item.seller).to.equal(addr1.address);
    expect(item.price).to.equal(ethers.utils.parseEther("1"));
    expect(item.tokenId).to.equal(1);
  });

  it("Should cancel an NFT sale", async function () {
    await mockERC721.connect(owner).mint(addr1.address, 1);
    await mockERC721.connect(addr1).approve(nftMarketplace.address, 1);
    await nftMarketplace.connect(addr1).startNFTSale(mockERC721.address, ethers.utils.parseEther("1"), 1);

    await nftMarketplace.connect(addr1).cancelNFTSale(0);

    const item = await nftMarketplace.idToItemForSale(0);
    expect(item.contractAddress).to.equal(ethers.constants.AddressZero);
    expect(item.seller).to.equal(ethers.constants.AddressZero);
  });

  it("Should allow an NFT to be bought", async function () {
    await mockERC721.connect(owner).mint(addr1.address, 1);
    await mockERC721.connect(addr1).approve(nftMarketplace.address, 1);
    await nftMarketplace.connect(addr1).startNFTSale(mockERC721.address, ethers.utils.parseEther("1"), 1);

    await nftMarketplace.connect(addr2).buyNFT(0, { value: ethers.utils.parseEther("1") });

    const item = await nftMarketplace.idToItemForSale(0);
    expect(item.buyer).to.equal(addr2.address);
    expect(item.state).to.equal(true);
  });

  it("Should start an NFT auction", async function () {
    await mockERC721.connect(owner).mint(addr1.address, 1);
    await mockERC721.connect(addr1).approve(nftMarketplace.address, 1);

    await nftMarketplace.connect(addr1).startNFTAuction(mockERC721.address, ethers.utils.parseEther("1"), 1, (await ethers.provider.getBlock()).timestamp + 3600);

    const item = await nftMarketplace.idToItemForAuction(0);
    expect(item.seller).to.equal(addr1.address);
    expect(item.startingPrice).to.equal(ethers.utils.parseEther("1"));
    expect(item.tokenId).to.equal(1);
  });

  it("Should allow a bid on an NFT auction", async function () {
    await mockERC721.connect(owner).mint(addr1.address, 1);
    await mockERC721.connect(addr1).approve(nftMarketplace.address, 1);

    await nftMarketplace.connect(addr1).startNFTAuction(mockERC721.address, ethers.utils.parseEther("1"), 1, (await ethers.provider.getBlock()).timestamp + 3600);

    await nftMarketplace.connect(addr2).bid(0, { value: ethers.utils.parseEther("2") });

    const item = await nftMarketplace.idToItemForAuction(0);
    expect(item.highestBid).to.equal(ethers.utils.parseEther("2"));
    expect(item.buyer).to.equal(addr2.address);
  });

  it("Should finish an NFT auction", async function () {
    await mockERC721.connect(owner).mint(addr1.address, 1);
    await mockERC721.connect(addr1).approve(nftMarketplace.address, 1);

    await nftMarketplace.connect(addr1).startNFTAuction(mockERC721.address, ethers.utils.parseEther("1"), 1, (await ethers.provider.getBlock()).timestamp + 1);

    await nftMarketplace.connect(addr2).bid(0, { value: ethers.utils.parseEther("2") });

    await ethers.provider.send("evm_increaseTime", [2]); // Increase time by 2 seconds
    await ethers.provider.send("evm_mine", []); // Mine a new block

    await nftMarketplace.connect(addr2).finishNFTAuction(0);

    const item = await nftMarketplace.idToItemForAuction(0);
    expect(item.state).to.equal(true);
  });
});
