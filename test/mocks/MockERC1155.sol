// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ERC1155} from '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

contract MockERC1155 is ERC1155, Ownable {
  uint256 private _currentTokenId = 0;

  constructor(string memory uri) ERC1155(uri) {}

  function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, _currentTokenId, amount, '');
    _currentTokenId++;
  }
}
