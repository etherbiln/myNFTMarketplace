// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./MyNFT.sol";
import "./Marketplace.sol";

contract Sale {
    uint idForSale;
    Marketplace public marketplace;

    struct ItemForSale {
        address contractAddress;
        address seller;
        address buyer;
        uint price;
        uint tokenId;
        bool isSold;
    }
    mapping(uint => ItemForSale) public idToItemForSale;

    event NFTSaleStarted(address contractAddress, uint256 price, uint256 tokenId);
    event NFTSaleCancelled(uint256 id, address contractAddress, uint256 tokenId);
    event NFTBought(uint256 id, address contractAddress, address seller, address buyer, uint256 price, uint256 tokenId);

    function startNFTSale(address contractAddress, uint price, uint tokenId) public {
        MyNFT NFT = MyNFT(contractAddress);
        require(NFT.ownerOf(tokenId) == msg.sender, "You are not owner of this NFT!"); 
        NFT.transferFrom(msg.sender, address(this), tokenId);
        
        idToItemForSale[idForSale] = ItemForSale(contractAddress, msg.sender, msg.sender, price, tokenId, false);
        idForSale += 1;

        emit NFTSaleStarted(contractAddress, price, tokenId);
    }

    function cancelNFTSale(uint Id) public {
        ItemForSale memory info = idToItemForSale[Id];
        MyNFT NFT = MyNFT(info.contractAddress);
       
        require(info.seller == msg.sender, "You are not owner of this NFT!");
        require(info.isSold == false, "This NFT sold!");

        idToItemForSale[Id] = ItemForSale(address(0), address(0), address(0), 0, 0, true);

        NFT.transferFrom(address(this), msg.sender, info.tokenId);        

        emit NFTSaleCancelled(Id, info.contractAddress, info.tokenId);
    }

    function buyNFT(uint Id) payable public {
        ItemForSale storage info = idToItemForSale[Id];
        require(Id < idForSale, "Invalid sale ID");
        require(msg.sender != info.seller, "You are seller");
        require(msg.value == info.price, "Wrong Price!");
        require(info.isSold == false, "Cannot buy!");

        info.buyer = msg.sender;
        info.isSold = true;

        MyNFT NFT = MyNFT(info.contractAddress);
        NFT.transferFrom(address(this), msg.sender, info.tokenId);
        
        uint price = msg.value * 95 / 100;
        payable(info.seller).transfer(price);
        payable(msg.sender).transfer(msg.value - price);   
        
        emit NFTBought(Id, info.contractAddress, info.seller, msg.sender, info.price, info.tokenId);
    }
    
    function isSaleActive(uint256 saleId) public view returns (bool) {
        ItemForSale storage info = idToItemForSale[saleId];
        return !info.isSold;
    }
}
