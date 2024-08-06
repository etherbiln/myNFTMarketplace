# Security Report: NFT Marketplace Contract

## Overview

This security report identifies and details potential vulnerabilities and issues in the NFT Marketplace smart contract. The focus is on reentrancy vulnerabilities, mathematical inaccuracies, and state management problems.

## Detected Issues

### 1. Reentrancy Vulnerabilities

#### `buyNFT(uint Id)`

**Issue:** Potential reentrancy vulnerability due to external calls followed by state changes.

- **External Calls:**
  - `NFT.transferFrom(address(this), msg.sender, info.tokenId)` (Line 83)
  - `payable(info.seller).transfer(price)` (Line 82)
  - `payable(owner).transfer(msg.value - price)` (Line 84)

- **State Change:**
  - `info.state = true` (Line 85)

**Risk:** Attackers may exploit this vulnerability to repeatedly call `buyNFT`, leading to possible fund drains or state manipulation.

**Recommendation:**

Apply the Checks-Effects-Interactions pattern and use Reentrancy Guards.

## Security Diagram

![Slither](images/Slither.png)

