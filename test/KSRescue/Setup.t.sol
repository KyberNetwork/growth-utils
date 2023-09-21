// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import 'forge-std/Test.sol';
import 'forge-std/console.sol';
import {MockKSRescue} from '../mocks/MockKSRescue.sol';
import {MockToken, MockToken2} from '../mocks/MockToken.sol';

contract KSRescueSetup is Test {
  uint256 public ownerPrivateKey;
  uint256 public opPrivateKey;
  uint256 public guardianPrivateKey;
  address public owner;
  address public operator;
  address public guardian;
  uint256 approveAmount;
  MockKSRescue public ksRescue;
  MockToken2 public token2;
  address public token2Addr;
  address public ksRescueAddr;
  address public constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

  function setUp() public virtual {
    ownerPrivateKey = 0xA11;
    opPrivateKey = 0xA22;
    guardianPrivateKey = 0xA33;
    approveAmount = 10_000 ether;

    owner = vm.addr(ownerPrivateKey);
    operator = vm.addr(opPrivateKey);
    guardian = vm.addr(guardianPrivateKey);

    vm.startPrank(owner);

    ksRescue = new MockKSRescue();
    token2 = new MockToken2('ZH', 'ZH');
    ksRescue.updateGuardian(guardian, true);
    ksRescue.updateOperator(operator, true);

    deal(address(token2), owner, approveAmount);
    deal(address(token2), operator, approveAmount);
    deal(address(token2), guardian, approveAmount);
    deal(owner, approveAmount);
    deal(operator, approveAmount);
    deal(guardian, approveAmount);

    token2Addr = address(token2);
    ksRescueAddr = address(ksRescue);
    vm.label(owner, 'owner');
    vm.label(operator, 'operator');
    vm.label(guardian, 'guardian');
    vm.label(ksRescueAddr, 'KSRescue');
    vm.label(token2Addr, 'ZH_Token');
  }
}
