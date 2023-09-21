// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {KyberSwapRole} from '@src/KyberSwapRole.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {SafeERC20} from '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

abstract contract KSRescue is KyberSwapRole {
  using SafeERC20 for IERC20;

  address private constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

  function rescueFunds(IERC20 token, uint256 amount, address recipient) external onlyOwner {
    require(recipient != address(0), 'KSRescue: invalid recipient');
    if (amount == 0) amount = _getAvailableAmount(token);
    if (amount > 0) {
      if (_isETH(token)) {
        (bool success,) = recipient.call{value: amount}('');
        require(success, 'KSRescue: ETH_TRANSFER_FAILED');
      } else {
        token.safeTransfer(recipient, amount);
      }
    }
  }

  function _getAvailableAmount(IERC20 token) internal view virtual returns (uint256 amount) {
    if (_isETH(token)) {
      amount = address(this).balance;
    } else {
      amount = token.balanceOf(address(this));
    }
    if (amount > 0) --amount;
  }

  function _isETH(IERC20 token) internal pure returns (bool) {
    return (address(token) == ETH_ADDRESS);
  }
}
