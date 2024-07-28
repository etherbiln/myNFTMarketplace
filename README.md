# NFT Marketplace

This project is an NFT (Non-Fungible Token) marketplace running on the Ethereum blockchain. Users can mint, sell, and buy NFTs that adhere to the ERC-721 standard. The marketplace provides several essential functions to support these activities:

Minting NFTs: Users can create their own unique NFTs by specifying metadata, such as the name, description, and image URL of the NFT. This process is handled by the mintNFT function.

Listing NFTs for Sale: After minting, users can list their NFTs for sale on the marketplace. The listNFT function allows users to set a price and make their NFTs available for purchase by others.

Buying NFTs: Users can browse the marketplace and buy NFTs listed by other users. The buyNFT function facilitates the purchase transaction, transferring the ownership of the NFT to the buyer and the payment to the seller.

Viewing Listed NFTs: The marketplace includes functionality for viewing all NFTs currently listed for sale, allowing users to explore available options and make informed purchasing decisions.

These features make the marketplace a comprehensive platform for NFT creators and collectors to engage in the buying, selling, and creation of digital assets on the Ethereum blockchain.

## Table of Contents

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Development](#development)
   - [Compile Smart Contracts](#compile-smart-contracts)
   - [Testing](#testing)
   - [Running on Local Network](#running-on-local-network)
   - [Deploying to Sepolia Network](#deploying-to-sepolia-network)
4. [Usage](#usage)
   - [Minting NFTs](#minting-nfts)
   - [Starting NFT Sale](#starting-nft-sale)
   - [Buying NFTs](#buying-nfts)

## Requirements

- Node.js (>= 14.x)
- npm or yarn
- Hardhat
- Ethers.js

## Installation

Follow these steps to set up the project:

1. Clone the repository:

    ```sh
    git clone https://github.com/ethermail/myNFTMarketplace.git
    ```

2. Navigate to the project directory:

    ```sh
    cd nft-marketplace
    ```

3. Install the dependencies:

    ```sh
    npm install
    ```

    or

    ```sh
    yarn install
    ```

4. Create a `.env` file and set the necessary environment variables:

    ```env
    INFURA_PROJECT_ID=your-infura-project-id
    DEPLOYER_PRIVATE_KEY=your-private-key
    ```

## Development

### Compile Smart Contracts

Compile the smart contracts by running the following command:

```sh
npx hardhat compile
```
test the smart contracts by running the following command:

```sh
npx hardhat test
```

deploy Sepolia
```sh
npx hardhat run scripts/deploy.js --network sepolia
```






