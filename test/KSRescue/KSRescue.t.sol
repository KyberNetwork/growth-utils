// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {KSRescueSetup} from './Setup.t.sol';
import {console} from 'forge-std/console.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {MockSC} from '../mocks/MockSC.sol';

contract KSRescueTest is KSRescueSetup {
  MockSC public mockSC;

  function setUp() public virtual override {
    super.setUp();
    mockSC = new MockSC();
  }

  function testRevertInvalidRole() public {
    deal(ksRescueAddr, approveAmount);

    vm.startPrank(operator);
    vm.expectRevert('Ownable: caller is not the owner');
    ksRescue.rescueFunds(ETH_ADDRESS, approveAmount, operator);
  }

  function testRevertNotReceiveETH() public {
    deal(ksRescueAddr, approveAmount);

    vm.startPrank(owner);
    vm.expectRevert('KSRescue: ETH_TRANSFER_FAILED');
    ksRescue.rescueFunds(ETH_ADDRESS, approveAmount, address(mockSC));
  }

  function testRescueETH() public {
    deal(ksRescueAddr, approveAmount);
    uint256 withdrawAmount = 300 ether;

    vm.startPrank(owner);
    uint256 balanceOwnerBefore = owner.balance;
    uint256 balanceSCBefore = ksRescueAddr.balance;
    ksRescue.rescueFunds(ETH_ADDRESS, withdrawAmount, owner);
    assertEq(balanceOwnerBefore + withdrawAmount, owner.balance);
    assertEq(balanceSCBefore - withdrawAmount, ksRescueAddr.balance);
  }

  function testRescueAllETH() public {
    deal(ksRescueAddr, approveAmount);

    vm.startPrank(owner);
    uint256 balanceOwnerBefore = owner.balance;
    uint256 balanceSCBefore = ksRescueAddr.balance;
    ksRescue.rescueFunds(ETH_ADDRESS, 0, owner);
    assertEq(balanceOwnerBefore + approveAmount - 1, owner.balance);
    assertEq(balanceSCBefore - approveAmount + 1, ksRescueAddr.balance);
  }

  function testRescueToken() public {
    deal(token2Addr, ksRescueAddr, approveAmount);
    uint256 withdrawAmount = 300 ether;

    vm.startPrank(owner);
    uint256 balanceOwnerBefore = token2.balanceOf(owner);
    uint256 balanceSCBefore = token2.balanceOf(ksRescueAddr);
    ksRescue.rescueFunds(token2Addr, withdrawAmount, owner);
    assertEq(balanceOwnerBefore + withdrawAmount, token2.balanceOf(owner));
    assertEq(balanceSCBefore - withdrawAmount, token2.balanceOf(ksRescueAddr));
  }

  function testRescueAllToken() public {
    deal(token2Addr, ksRescueAddr, approveAmount);

    vm.startPrank(owner);
    uint256 balanceOwnerBefore = token2.balanceOf(owner);
    uint256 balanceSCBefore = token2.balanceOf(ksRescueAddr);
    ksRescue.rescueFunds(token2Addr, 0, owner);
    assertEq(balanceOwnerBefore + approveAmount - 1, token2.balanceOf(owner));
    assertEq(balanceSCBefore - approveAmount + 1, token2.balanceOf(ksRescueAddr));
  }
}
