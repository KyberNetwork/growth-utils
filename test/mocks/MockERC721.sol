// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ERC721} from '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

contract MockERC721 is ERC721, Ownable {
  uint256 private _currentTokenId = 0;

  constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

  function mint(address to) external onlyOwner {
    _mint(to, _currentTokenId);
    _currentTokenId++;
  }
}
