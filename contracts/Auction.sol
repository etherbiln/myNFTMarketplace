// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Auction {
    uint256 idForAuction;
    mapping(uint => ItemForAuction) public idToItemForAuction;

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

    function bid(uint256 Id) public payable {
        ItemForAuction storage info = idToItemForAuction[Id];
        require(Id < idForAuction);
        require(msg.sender != info.seller, "You are not owner of this NFT!");
        require(msg.value > info.highestBid, "There already is a higher bid.");

        if (info.highestBid != 0) {
            payable(info.buyer).transfer(info.highestBid);
        }

        info.buyer = msg.sender;
        info.highestBid = msg.value;
    }
    function finishNFTAuction(uint256 Id) public {
        ItemForAuction storage info = idToItemForAuction[Id];
        require(Id < idForAuction, "Invalid auction ID");
        require(msg.sender == info.buyer, "You are not the highest bidder");
        require(!info.isFinished, "Auction already finished");
        require(block.timestamp > info.deadline, "Auction not yet finished");
        require(info.buyer != info.seller, "No bids received");
        address owner =msg.sender;
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
