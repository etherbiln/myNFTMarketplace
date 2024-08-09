// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./MyNFT.sol";

contract Auction {
    uint256 idForAuction;

    struct ItemForAuction{
        address contractAddress;
        address seller;
        address buyer;
        uint startingPrice;
        uint highestBid;
        uint tokenId;
        uint deadline;
        bool isFinished;
    }

    mapping(uint => ItemForAuction) public idToItemForAuction;

    function startNFTAuction(address contractAddress, uint256 startingPrice, uint256 tokenId, uint256 deadline) public {
        IERC721 myNFT = IERC721(contractAddress);
        require(myNFT.ownerOf(tokenId) == msg.sender, "You are not owner of this NFT!");
        
        myNFT.transferFrom(msg.sender, address(this), tokenId);
        
        idToItemForAuction[idForAuction] = ItemForAuction(contractAddress, msg.sender, address(0), startingPrice, 0, deadline, tokenId, false);
        idForAuction += 1;
    }


    function cancelNFTAuction(uint256 Id) public {
        ItemForAuction storage info = idToItemForAuction[Id];
        IERC721 NFT = IERC721(info.contractAddress);
        require(info.seller == msg.sender, "You are not owner of this NFT!");
        require(info.isFinished == false, "This NFT sold!");

        idToItemForAuction[Id] = ItemForAuction(address(0), address(0), address(0),0,0,0,0,true);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);
    }

    function bid(uint256 Id) public payable {
        ItemForAuction storage info = idToItemForAuction[Id];

        require(Id < idForAuction);
        require(msg.sender != info.seller, "You are seller");
        require(msg.sender != info.buyer, "You have highest bid!");
        require(msg.value >= info.startingPrice, "Wrong Price!");
        require(msg.value > info.highestBid, "Wrong Price!");
        require(info.isFinished= false, "Cannot buy!");
        require(block.timestamp < info.deadline, "Deadline!");
        
       if(info.seller == info.buyer){
            info.buyer = msg.sender;
            info.highestBid = msg.value;
        }else{
            payable(info.buyer).transfer(info.highestBid);
            info.buyer = msg.sender;
            info.highestBid = msg.value;
        }
    }

    function finishNFTAuction(uint256 Id) public payable  {
        ItemForAuction storage info = idToItemForAuction[Id];
        IERC721 NFT = IERC721(info.contractAddress);

        require(Id < idForAuction, "Invalid auction ID");
        require(msg.sender == info.buyer, "You are not the highest bidder");
        require(!info.isFinished, "Auction already finished");
        require(block.timestamp > info.deadline, "Auction not yet finished");
        require(info.buyer != info.seller, "No bids received");

        info.isFinished = true;

        uint price = info.highestBid * 95 / 100;
        payable(info.seller).transfer(price);
        payable(msg.sender).transfer(msg.value - price);
       
        idToItemForAuction[Id] = ItemForAuction(address(0), address(0), address(0),0,0,0,0,true);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);
    }
    
    function isAuctionActive(uint256 saleId) public view returns (bool) {
        ItemForAuction storage info = idToItemForAuction[saleId];
        return !info.isFinished;
    }
}
