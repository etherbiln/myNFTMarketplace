# 🎨 NFT Marketplace

## 📝 Overview

The **NFT Marketplace** is a decentralized platform for buying, selling, and auctioning NFTs (Non-Fungible Tokens). This contract allows users to list their NFTs for sale or auction, and buyers can purchase or bid on these NFTs. The marketplace also supports royalty payments to the creators of the NFTs.

## ✨ Features

- **NFT Sale**: List NFTs for sale at a fixed price.
- **NFT Auction**: List NFTs for auction with a starting price and deadline.
- **Royalty Payments**: Automatically distribute royalties to the creators of the NFTs on each sale.
- **Cancel Sale/Auction**: Sellers can cancel their listings if they are not sold or auctioned.
- **Secure Payments**: Ensure secure payment transfers between buyers and sellers, including a marketplace fee.
- **Bid System**: Allow users to place bids on NFTs listed for auction.
- **Finish Auction**: Automatically finalize the auction process and transfer the NFT to the highest bidder.
- **Ownership Verification**: Verify the ownership of NFTs before listing them for sale or auction.
- **Upgradeable Contract**: Support for contract upgrades using a proxy model.

## 🛠 How I Designed the Project

### Project Initialization
Before starting the project, I set up the development environment and installed the necessary dependencies. These dependencies included **Hardhat**, **OpenZeppelin Contracts**, **Slither**, and **Echidna**. This step laid a solid foundation for the project and helped me carry out subsequent steps more efficiently.

### Smart Contract Development
I developed the smart contracts for the NFT Marketplace. In this phase, I carefully defined the structures for items listed for sale and auction. I successfully implemented functions for initiating, canceling, and purchasing NFTs through sales and auctions. This established the core functionality of the marketplace, providing a platform that meets users' needs.

### Testing
To ensure that the smart contracts functioned as expected, I wrote and executed comprehensive tests. I performed in-depth static analysis with **Slither** to identify potential security vulnerabilities and conducted fuzz testing with **Echidna** to ensure robustness. This step enhanced the project's reliability and resilience, providing a secure environment for users.

### Review and Optimization
Finally, I meticulously reviewed the smart contract code and optimized it for gas efficiency and security. I addressed issues identified during testing and static analysis with great care. This step maximized the project's performance and security, enhancing the user experience.

## 🚀 Development

### Setting Up the Development Environment

1. **Install Dependencies**:
    - **Hardhat**: A development environment to compile, deploy, test, and debug your Ethereum software.
    - **OpenZeppelin Contracts**: A library for secure smart contract development.
    - **Docker**: To create a consistent development environment.

    ```sh
    npm install --save-dev hardhat @openzeppelin/contracts
    ```

2. **Initialize Hardhat**:
    - Create a new Hardhat project.

    ```sh
    npx hardhat
    ```
    

### Deploy Smart Contracts

Create a `.env` file and set the necessary environment variables:

```env
INFURA_PROJECT_ID=your-infura-project-id
DEPLOYER_PRIVATE_KEY=your-private-key
```
### Deploy Sepolia
```
npx hardhat run scripts/deploy.js --network sepolia
```
