// Gerekli modülleri içe aktar
const { ethers } = require("ethers");
require('dotenv').config(); // .env dosyasını yükle

// .env dosyasından bilgileri al
const provider = new ethers.providers.JsonRpcProvider(process.env.INFURA_SEPOLIA_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const marketplaceAddress = process.env.MARKETPLACE_CONTRACT_ADDRESS;
const marketplaceABI = [
    "function startNFTSale(address contractAddress, uint256 priceNFT, uint256 tokenId) public"
];

const marketplaceContract = new ethers.Contract(marketplaceAddress, marketplaceABI, wallet);

async function startNFTSale() {
    try {
        const nftContractAddress = process.env.NFT_CONTRACT_ADDRESS;
        const priceNFT = ethers.utils.parseEther("0.1");
        const tokenId = 1;

        const transaction = await marketplaceContract.startNFTSale(nftContractAddress, priceNFT, tokenId, {
            gasLimit: 1000000 // Belirli bir gaz limiti ayarlayın
        });

        const receipt = await transaction.wait();

        console.log("NFT başarıyla satışa çıkarıldı:", receipt);
    } catch (error) {
        console.error("Bir hata oluştu:", error);
    }

}

// NFT satışını başlat
startNFTSale();
