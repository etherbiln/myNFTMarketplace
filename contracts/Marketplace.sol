// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./MyNFT.sol";
import "./Sale.sol";
import "./Auction.sol";

contract Marketplace {
    Sale public saleContract;
    Auction public auctionContract;

    constructor()  {
        saleContract = new Sale();
        auctionContract = new Auction();
    }
       
    function approveMarketplaceForAll(address nftContract) public {
        IERC721(nftContract).setApprovalForAll(address(this), true);
    }

    function startNFTSale(address contractAddress, uint256 priceNFT, uint256 tokenId) public payable  {
        saleContract.startNFTSale(contractAddress, priceNFT, tokenId);
    }

    function cancelNFTSale(uint256 Id) public {
        saleContract.cancelNFTSale(Id);
    }

    function buyNFT(uint256 Id) public payable {
        saleContract.buyNFT{value: msg.value}(Id);
    }

    function startNFTAuction(address contractAddress, uint256 startingPrice, uint256 tokenId, uint256 deadline) public {
        auctionContract.startNFTAuction(contractAddress, startingPrice, tokenId, deadline);
    }

    function cancelNFTAuction(uint256 Id) public {
        auctionContract.cancelNFTAuction(Id);
    }

    function bid(uint256 Id) public payable {
        auctionContract.bid{value: msg.value}(Id);
    }
    
    function finishNFTAuction(uint256 Id) public {
        auctionContract.finishNFTAuction(Id);
    }

    function setSaleContract(address _saleContract) external {
        saleContract = Sale(_saleContract);
    }

    function setAuctionContract(address _auctionContract) external {
        auctionContract = Auction(_auctionContract);
    }
}
