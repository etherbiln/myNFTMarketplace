// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "./Sale.sol";
import "./Auction.sol";
import "./Utils.sol";

contract Marketplace {
    address public owner;
    Sale public saleContract;
    Auction public auctionContract;

    constructor()  {
        owner = msg.sender;
        saleContract = new Sale();
        auctionContract = new Auction();
    }

    function startNFTSale(address contractAddress, uint256 priceNFT, uint256 tokenId, uint256 royaltyPercentage) public {
        saleContract.startNFTSale(contractAddress, priceNFT, tokenId, royaltyPercentage, owner);
    }

    function cancelNFTSale(uint256 Id) public {
        saleContract.cancelNFTSale(Id, owner);
    }

    function buyNFT(uint256 Id) public payable {
        saleContract.buyNFT{value: msg.value}(Id, owner);
    }

    function startNFTAuction(address contractAddress, uint256 startingPrice, uint256 tokenId, uint256 deadline, uint256 royaltyPercentage) public {
        auctionContract.startNFTAuction(contractAddress, startingPrice, tokenId, deadline, royaltyPercentage);
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
}
