// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library Utils {
    function calculateRoyalty(uint256 amount, uint256 royaltyPercentage) internal pure returns (uint256) {
        return (amount * royaltyPercentage) / 100;
    }

    function calculateSellerAmount(uint256 amount, uint256 royaltyAmount) internal pure returns (uint256) {
        return (amount * 95 / 100) - royaltyAmount;
    }
}
