// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract MyNFT is ERC721, Ownable, Pausable {
    uint256 private _tokenIds;

    constructor(address initialOwner) ERC721("MyNFT", "MFT") Ownable(initialOwner) {}

    function mint(address to, uint256 tokenId) public onlyOwner whenNotPaused {
        _mint(to, tokenId);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function burn(uint256 tokenId) public onlyOwner whenNotPaused {
        _burn(tokenId);
    }
}
