// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {KSRescueV2} from '@src/KSRescueV2.sol';
import {IERC1155Receiver} from '@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol';
import {IERC721Receiver} from '@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol';

contract MockKSRescueV2 is KSRescueV2, IERC1155Receiver, IERC721Receiver {
  /**
   * @notice Handles ERC1155 Token callback.
   * return Standardized onERC1155Received return value.
   */
  function onERC1155Received(
    address,
    address,
    uint256,
    uint256,
    bytes calldata
  ) external pure override returns (bytes4) {
    return 0xf23a6e61;
  }

  /**
   * @notice Handles ERC1155 Token batch callback.
   * return Standardized onERC1155BatchReceived return value.
   */
  function onERC1155BatchReceived(
    address,
    address,
    uint256[] calldata,
    uint256[] calldata,
    bytes calldata
  ) external pure override returns (bytes4) {
    return 0xbc197c81;
  }

  /**
   * @notice Handles ERC721 Token callback.
   *  return Standardized onERC721Received return value.
   */
  function onERC721Received(
    address,
    address,
    uint256,
    bytes calldata
  ) external pure override returns (bytes4) {
    return 0x150b7a02;
  }

  /**
   * @notice Implements ERC165 interface support for ERC1155TokenReceiver, ERC721TokenReceiver and IERC165.
   * @param interfaceId Id of the interface.
   * @return if the interface is supported.
   */
  function supportsInterface(bytes4 interfaceId) external view virtual override returns (bool) {
    return interfaceId == type(IERC1155Receiver).interfaceId
      || interfaceId == type(IERC721Receiver).interfaceId;
  }
}
