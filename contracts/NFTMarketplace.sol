// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract NFTMarketplace is Initializable {
    address public owner;
    uint256 idForSale;
    uint256 idForAuction;
    uint256  price = msg.value * 95 / 100;

    struct ItemForSale {
        address contractAddress;
        address seller;
        address buyer;
        address creator; 
        uint price;
        uint tokenId;
        uint royaltyPercentage;
        bool state;
    }

    struct ItemForAuction {
        address contractAddress;
        address seller;
        address buyer;
        address creator;
        uint startingPrice;
        uint highestBid;
        uint tokenId;
        uint royaltyPercentage; 
        uint deadline;
        bool state;
        bool isFinished;
    }

    mapping(uint => ItemForSale) public idToItemForSale;
    mapping(uint => ItemForAuction) public idToItemForAuction;

    function initialize() public initializer {
        owner = msg.sender;
    }

    function startNFTSale(address contractAddress, uint256 priceNFT, uint256 tokenId, uint256 royaltyPercentage) public {
        IERC721 NFT = IERC721(contractAddress);
        require(NFT.ownerOf(tokenId) == msg.sender, "You are not owner of this NFT!");
        NFT.transferFrom(msg.sender, address(this), tokenId);
        idToItemForSale[idForSale] = ItemForSale(contractAddress, msg.sender, msg.sender, msg.sender, priceNFT, tokenId, royaltyPercentage,false);
        idForSale += 1;
    }

    function startNFTAuction(address contractAddress, uint256 priceNFT, uint256 tokenId, uint256 deadline, uint256 royaltyPercentage) public {
        IERC721 NFT = IERC721(contractAddress);
        require(NFT.ownerOf(tokenId) == msg.sender, "You are not owner of this NFT!");
        
        NFT.transferFrom(msg.sender, address(this), tokenId);
        idToItemForAuction[idForAuction] = ItemForAuction(contractAddress, msg.sender, msg.sender, msg.sender, priceNFT, 0, tokenId, royaltyPercentage, deadline, false, false);
        idForAuction += 1;
    }

    function cancelNFTAuction(uint256 Id) public {
        ItemForAuction storage info = idToItemForAuction[Id];
        require(info.seller == msg.sender, "You are not owner of this NFT!");
        require(info.state == false, "This NFT sold!");
    
        info.state = true;
    
        IERC721 NFT = IERC721(info.contractAddress);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);
    }

    function cancelNFTSale(uint256 Id) public {
        ItemForSale storage info = idToItemForSale[Id];
        require(info.seller == msg.sender, "You are not owner of this NFT!");
        require(info.state == false, "This NFT sold!");
    
        info.state = true;
    
        IERC721 NFT = IERC721(info.contractAddress);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);
    }

    function buyNFT(uint256 Id) public payable {
        ItemForSale storage info = idToItemForSale[Id];
        require(Id < idForSale, "Invalid sale ID");
        require(msg.sender != info.seller, "You are the seller");
        require(msg.value == info.price, "Incorrect price");
        require(!info.state, "NFT already sold");

        info.buyer = msg.sender;
        info.state = true;

        IERC721 NFT = IERC721(info.contractAddress);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);

        uint royaltyAmount = msg.value * info.royaltyPercentage / 100;
        uint sellerAmount = msg.value * 95 / 100 - royaltyAmount;
        payable(info.creator).transfer(royaltyAmount);
        payable(info.seller).transfer(sellerAmount);
        payable(owner).transfer(msg.value - sellerAmount - royaltyAmount);
    }

    function bid(uint256 Id) public payable {
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
        info.buyer = msg.sender;
        info.state = true;
    }

    function finishNFTAuction(uint256 Id) public {
        ItemForAuction storage info = idToItemForAuction[Id];
        require(Id < idForAuction, "Invalid auction ID");
        require(msg.sender == info.buyer, "You are not the highest bidder");
        require(!info.isFinished, "Auction already finished");
        require(block.timestamp > info.deadline, "Auction not yet finished");
        require(info.buyer != info.seller, "No bids received");

        info.isFinished = true;

        IERC721 NFT = IERC721(info.contractAddress);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);

        uint256 royaltyAmount = info.highestBid * info.royaltyPercentage / 100;
        uint256 sellerAmount = info.highestBid * 95 / 100 - royaltyAmount;
        payable(info.creator).transfer(royaltyAmount);
        payable(info.seller).transfer(sellerAmount);
        payable(owner).transfer(info.highestBid - sellerAmount - royaltyAmount);
    }
}
