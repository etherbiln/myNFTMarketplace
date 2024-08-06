// contracts/NFTMarketplace.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarketplace {
    address public owner;
    uint idForSale;
    uint idForAuction;
    uint  price = msg.value * 95 / 100;

    struct ItemForSale {
        address contractAddress;
        address seller;
        address buyer;
        uint price;
        uint tokenId;
        bool state;
        bool isSold;
    }

    struct ItemForAuction {
        address contractAddress;
        address seller;
        address buyer;
        uint startingPrice;
        uint highestBid;
        uint tokenId;
        uint deadline;
        bool state;
        bool isFinished;
    }

    mapping(uint => ItemForSale) public idToItemForSale;
    mapping(uint => ItemForAuction) public idToItemForAuction;

    constructor() {
        owner = msg.sender;
    }

    function startNFTSale(address contractAddress, uint priceNFT, uint tokenId) public {
        IERC721 NFT = IERC721(contractAddress);
        require(NFT.ownerOf(tokenId) == msg.sender, "You are not owner of this NFT!");
        NFT.transferFrom(msg.sender, address(this), tokenId);
        idToItemForSale[idForSale] = ItemForSale(contractAddress, msg.sender, msg.sender, priceNFT, tokenId, false,false);
        idForSale += 1;
    }

    function cancelNFTSale(uint Id) public {
        ItemForSale memory info = idToItemForSale[Id];
        IERC721 NFT = IERC721(info.contractAddress);
        require(info.seller == msg.sender, "You are not owner of this NFT!");
        require(info.state == false, "This NFT sold!");
        NFT.transferFrom(address(this), msg.sender, info.tokenId);
        idToItemForSale[Id] = ItemForSale(address(0), address(0), address(0), 0, 0, true,false);
    }

    function startNFTAuction(address contractAddress, uint priceNFT, uint tokenId, uint deadline) public {
        IERC721 NFT = IERC721(contractAddress);
        require(NFT.ownerOf(tokenId) == msg.sender, "You are not owner of this NFT!");
        NFT.transferFrom(msg.sender, address(this), tokenId);
        idToItemForAuction[idForAuction] = ItemForAuction(contractAddress, msg.sender, msg.sender, priceNFT, 0, tokenId, deadline, false,false);
        idForAuction += 1;
    }

    function cancelNFTAuction(uint Id) public {
        ItemForAuction memory info = idToItemForAuction[Id];
        IERC721 NFT = IERC721(info.contractAddress);
        require(info.seller == msg.sender, "You are not owner of this NFT!");
        require(info.state == false, "This NFT sold!");
        NFT.transferFrom(address(this), msg.sender, info.tokenId);
        idToItemForAuction[Id] = ItemForAuction(address(0), address(0), address(0), 0, 0, 0, 0, true,false);
    }

    function buyNFT(uint Id) payable public {
        ItemForSale storage info = idToItemForSale[Id];
        require(Id < idForSale, "Invalid sale ID");
        require(msg.sender != info.seller, "You are the seller");
        require(msg.value == info.price, "Incorrect price");
        require(!info.isSold, "NFT already sold");

        // Update state before external calls
        info.buyer = msg.sender;
        info.isSold = true;

        IERC721 NFT = IERC721(info.contractAddress);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);

        uint sellerAmount = msg.value * 95 / 100;
        payable(info.seller).transfer(sellerAmount);
        payable(owner).transfer(msg.value - sellerAmount);
    }

    function bid(uint Id) payable public {
        ItemForAuction storage info = idToItemForAuction[Id];
        require(Id < idForAuction);
        require(msg.sender != info.seller, "You are seller");
        require(msg.sender != info.buyer, "You have highest bid!");
        require(msg.value >= info.startingPrice, "Wrong Price!");
        require(msg.value > info.highestBid, "Wrong Price!");
        require(info.state == false, "Cannot buy!");
        require(block.timestamp < info.deadline, "Deadline!");
        if (info.seller == info.buyer) {
            info.buyer = msg.sender;
            info.highestBid = msg.value;
        } else {
            payable(info.buyer).transfer(info.highestBid);
            info.buyer = msg.sender;
            info.highestBid = msg.value;
        }
    }
    function finishNFTAuction(uint Id) public {
        ItemForAuction storage info = idToItemForAuction[Id];
        require(Id < idForAuction, "Invalid auction ID");
        require(msg.sender == info.buyer, "You are not the highest bidder");
        require(!info.isFinished, "Auction already finished");
        require(block.timestamp > info.deadline, "Auction not yet finished");
        require(info.buyer != info.seller, "No bids received");

        // Update state before external calls
        info.isFinished = true;

        IERC721 NFT = IERC721(info.contractAddress);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);

        uint sellerAmount = info.highestBid * 95 / 100;
        payable(info.seller).transfer(sellerAmount);
        payable(owner).transfer(info.highestBid - sellerAmount);
    }

}
