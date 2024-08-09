// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "contracts/Sale.sol";
import "contracts/MyNFT.sol";

contract TestSale is Sale {
    MyNFT public myNFT;
    uint256 public testTokenId;

    constructor() {
        myNFT = new MyNFT(address(this));
    }

    function invariant_pricePositive() public view returns (bool) {
        for (uint i = 0; i < idForSale; i++) {
            if (idToItemForSale[i].price <= 0) {
                return false;
            }
        }
        return true;
    }


    function invariant_nftNotSold() public view returns (bool) {
        for (uint i = 0; i < idForSale; i++) {
            if (idToItemForSale[i].isSold == true && idToItemForSale[i].buyer == address(0)) {
                return false;
            }
        }
        return true;
    }

    function echidna_test_Sale() public returns (bool) { 
        testTokenId = myNFT.mint(address(this));
        startNFTSale(address(myNFT), 1 ether, testTokenId);
        return true;
    }
    
    function echidna_test() public pure returns (bool) {
        return true;
    }
}

//     function echidna_testCancelNFTSale() public returns (bool) {
//         startSale();
//         saleContract.cancelNFTSale(testSaleId);
//         return true;
//     }

//     function echidna_testBuyNFT() public payable returns (bool) {
//         startSale();
//         saleContract.buyNFT{value: 1 ether}(testSaleId);
//         return true;
//     }

//     function echidna_testStartNFTAuction() public returns (bool) {
//         startAuction();
//         return true;
//     }

//     function echidna_testBid() public payable returns (bool) {
//         startAuction();
//         auctionContract.bid{value: 1 ether}(testAuctionId);
//         return true;
//     }

//     function echidna_testFinishNFTAuction() public returns (bool) {
//         startAuction();
//         auctionContract.bid{value: 1 ether}(testAuctionId);
//         auctionContract.finishNFTAuction(testAuctionId);
//         return true;
//     }

//     function echidna_testNftOwnershipAfterBuy() public returns (bool) {
//         startSale();
//         saleContract.buyNFT{value: 1 ether}(testSaleId);
//         IERC721 nft = IERC721(address(this));
//         require(nft.ownerOf(testTokenId) == msg.sender, "NFT ownership test after buy failed");
//         return true;
//     }

//     function echidna_testNftOwnershipAfterAuction() public payable returns (bool) {
//         startAuction();
//         auctionContract.bid{value: 1 ether}(testAuctionId);
//         auctionContract.finishNFTAuction(testAuctionId);
//         IERC721 nft = IERC721(address(this));
//         require(nft.ownerOf(testTokenId) == msg.sender, "NFT ownership test after auction finish failed");
//         return true;
//     }
// }
