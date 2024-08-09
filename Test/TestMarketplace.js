const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Marketplace Contract", function () {
  let Marketplace, marketplace;
  let Sale, sale;
  let Auction, auction;
  let NFT, nft;
  let owner, addr1, addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    // Deploy contracts
    Marketplace = await ethers.getContractFactory("Marketplace");
    marketplace = await Marketplace.deploy();
    await marketplace.deployed();

    Sale = await ethers.getContractFactory("Sale");
    sale = await Sale.deploy();
    await sale.deployed();

    Auction = await ethers.getContractFactory("Auction");
    auction = await Auction.deploy();
    await auction.deployed();

    NFT = await ethers.getContractFactory("MyNFT");
    nft = await NFT.deploy(owner.address);
    await nft.deployed();

    // Set Sale and Auction contracts in Marketplace
    await marketplace.setSaleContract(sale.address);
    await marketplace.setAuctionContract(auction.address);

    // Approve Marketplace to manage NFTs
    await nft.connect(owner).setApprovalForAll(marketplace.address, true);
  });

  it("Should correctly set Sale and Auction contracts in Marketplace", async function () {
    expect(await marketplace.saleContract()).to.equal(sale.address);
    expect(await marketplace.auctionContract()).to.equal(auction.address);
  });

  it("Should correctly approve Marketplace to manage NFTs", async function () {
    const isApproved = await nft.isApprovedForAll(owner.address, marketplace.address);
    expect(isApproved).to.be.true;
  });

});
