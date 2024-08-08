async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const balance = await deployer.getBalance();
  console.log("Account balance:", balance.toString());

  const NFTMarketplace = await ethers.getContractFactory("Marketplace");
  const nftMarketplace = await NFTMarketplace.deploy();
  await nftMarketplace.deployed();

  console.log("Marketplace deployed to:", nftMarketplace.address);

  const MyNFT = await ethers.getContractFactory("MyNFT");
  const initialAddress = "0x1405Ee3D5aF0EEe632b7ece9c31fA94809e6030d"; // initial Address
  const myNFT = await MyNFT.deploy(initialAddress);
  await myNFT.deployed();

  console.log("MyNFT deployed to:", myNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
