// contracts/MockERC721.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockERC721 is ERC721 {
    uint256 private _tokenId;

    constructor() ERC721("MockERC721", "M721") {}

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }
}
