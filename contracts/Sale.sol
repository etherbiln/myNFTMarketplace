// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Sale {
    uint256 idForSale;
    mapping(uint => ItemForSale) public idToItemForSale;

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

    function startNFTSale(address contractAddress, uint256 priceNFT, uint256 tokenId, uint256 royaltyPercentage, address owner) public {
        IERC721 NFT = IERC721(contractAddress);
        require(NFT.ownerOf(tokenId) == msg.sender, "You are not owner of this NFT!");
        NFT.transferFrom(msg.sender, address(this), tokenId);
        idToItemForSale[idForSale] = ItemForSale(contractAddress, msg.sender, msg.sender, msg.sender, priceNFT, tokenId, royaltyPercentage, false);
        idForSale += 1;
        owner = msg.sender;
    }

    function cancelNFTSale(uint256 Id, address owner) public {

        ItemForSale storage info = idToItemForSale[Id];
        require(info.seller == msg.sender, "You are not owner of this NFT!");
        require(info.state == false, "This NFT sold!");
        owner = info.seller;
        info.state = true;
    
        IERC721 NFT = IERC721(info.contractAddress);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);
    }

    function buyNFT(uint256 Id, address owner) public payable {
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
}
