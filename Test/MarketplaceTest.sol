// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../contracts/Marketplace.sol";

contract MarketplaceTest is Marketplace {
    constructor() Marketplace() {}

    function echidna_sale_contract_initialized() public view returns (bool) {
        return address(saleContract) != address(0);
    }

    function echidna_auction_contract_initialized() public view returns (bool) {
        return address(auctionContract) != address(0);
    }

    function echidna_approve_marketplace() public returns (bool) {
        address nftContract = address(0x123);
        approveMarketplaceForAll(nftContract);
        return IERC721(nftContract).isApprovedForAll(address(this), address(this));
    }

    function echidna_start_nft_sale() public returns (bool) {
        address nftContract = address(0x123);
        uint256 priceNFT = 1 ether;
        uint256 tokenId = 1;
        startNFTSale(nftContract, priceNFT, tokenId);
        return saleContract.isSaleActive(tokenId);
    }

    function echidna_start_nft_auction() public returns (bool) {
        address nftContract = address(0x123);
        uint256 startingPrice = 1 ether;
        uint256 tokenId = 1;
        uint256 deadline = block.timestamp + 1 days;
        startNFTAuction(nftContract, startingPrice, tokenId, deadline);
        return auctionContract.isAuctionActive(tokenId);
    }
}