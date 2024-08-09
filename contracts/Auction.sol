// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./MyNFT.sol";

contract Auction {
    uint256 idForAuction;

    struct ItemForAuction {
        address contractAddress;
        address seller;
        address buyer;
        uint256 startingPrice;
        uint256 highestBid;
        uint256 tokenId;
        uint256 deadline;
        bool isFinished;
    }

    mapping(uint256 => ItemForAuction) public idToItemForAuction;

    event NFTAuctionStarted(address contractAddress, uint256 startingPrice, uint256 tokenId, uint256 deadline);
    event NFTAuctionCancelled(uint256 id, address contractAddress, uint256 tokenId);
    event NFTBidPlaced(uint256 id, address bidder, uint256 bidAmount);
    event NFTAuctionFinished(uint256 id, address buyer, uint256 price, uint256 tokenId);

    function startNFTAuction(address contractAddress, uint256 startingPrice, uint256 tokenId, uint256 deadline) public {
        MyNFT myNFT = MyNFT(contractAddress);
        require(myNFT.ownerOf(tokenId) == msg.sender, "You are not owner of this NFT!");
        
        myNFT.transferFrom(msg.sender, address(this), tokenId);
        
        idToItemForAuction[idForAuction] = ItemForAuction(contractAddress, msg.sender, address(0), startingPrice, 0, tokenId, deadline, false);
        idForAuction += 1;

        emit NFTAuctionStarted(contractAddress, startingPrice, tokenId, deadline);
    }

    function cancelNFTAuction(uint256 id) public {
        ItemForAuction storage info = idToItemForAuction[id];
        MyNFT nft = MyNFT(info.contractAddress);
        require(info.seller == msg.sender, "You are not owner of this NFT!");
        require(!info.isFinished, "This auction is already finished!");

        if (info.highestBid > 0) {
            payable(info.buyer).transfer(info.highestBid);
        }

        nft.transferFrom(address(this), msg.sender, info.tokenId);
        delete idToItemForAuction[id];

        emit NFTAuctionCancelled(id, info.contractAddress, info.tokenId);
    }

    function bid(uint256 id) public payable {
        ItemForAuction storage info = idToItemForAuction[id];

        require(id < idForAuction, "Invalid auction ID");
        require(msg.sender != info.seller, "Seller cannot place a bid");
        require(msg.sender != info.buyer || msg.value > info.highestBid, "You already have the highest bid or not enough");
        require(msg.value >= info.startingPrice, "Bid below starting price");
        require(msg.value > info.highestBid, "Bid not higher than current highest bid");
        require(!info.isFinished, "Auction has ended");
        require(block.timestamp < info.deadline, "Auction deadline passed");

        if (info.highestBid > 0) {
            payable(info.buyer).transfer(info.highestBid);
        }

        info.buyer = msg.sender;
        info.highestBid = msg.value;

        emit NFTBidPlaced(id, msg.sender, msg.value);
    }

    function finishNFTAuction(uint256 id) public payable {
        ItemForAuction storage info = idToItemForAuction[id];
        MyNFT nft = MyNFT(info.contractAddress);

        require(id < idForAuction, "Invalid auction ID");
        require(msg.sender == info.buyer, "Only the highest bidder can finish the auction");
        require(!info.isFinished, "Auction already finished");
        require(block.timestamp > info.deadline, "Auction not yet finished");
        require(info.buyer != info.seller, "No bids were placed");

        info.isFinished = true;

        uint256 price = info.highestBid * 95 / 100;
        payable(info.seller).transfer(price);
        // Refund the remaining ETH to the buyer
        if (msg.value > info.highestBid) {
            payable(msg.sender).transfer(msg.value - info.highestBid);
        }
       
        nft.transferFrom(address(this), msg.sender, info.tokenId);
        delete idToItemForAuction[id];

        emit NFTAuctionFinished(id, msg.sender, info.highestBid, info.tokenId);
    }

    function isAuctionActive(uint256 auctionId) public view returns (bool) {
        ItemForAuction storage info = idToItemForAuction[auctionId];
        return !info.isFinished && block.timestamp < info.deadline;
    }
}
