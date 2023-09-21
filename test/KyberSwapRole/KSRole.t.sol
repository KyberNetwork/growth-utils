// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {KSRoleSetup} from './Setup.t.sol';
import {console} from 'forge-std/console.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {MockSC} from '../mocks/MockSC.sol';

contract KSRoleTest is KSRoleSetup {
  function setUp() public override {
    super.setUp();
  }

  function testRevertInvalidOwner() public {
    vm.startPrank(operator);
    vm.expectRevert('Ownable: caller is not the owner');
    ksRole.updateOperator(operator, true);
  }

  function testRevertInvalidOwnerResetLogic() public {
    vm.startPrank(guardian);
    ksRole.disableLogic();
    vm.expectRevert('Ownable: caller is not the owner');
    ksRole.enableLogic();
  }

  function testRevertInvalidOperator() public {
    vm.startPrank(guardian);
    vm.expectRevert('KyberSwapRole: not operator');
    ksRole.setZohar(address(1));
  }

  function testRevertInvalidGuardian() public {
    vm.startPrank(operator);
    vm.expectRevert('KyberSwapRole: not guardian');
    ksRole.disableLogic();
  }

  function testRevertWhenPaused() public {
    vm.startPrank(guardian);
    ksRole.disableLogic();
    vm.expectRevert('Pausable: paused');
    ksRole.setZohar2(address(1));
  }

  function testRevertWhenNotPaused() public {
    vm.startPrank(operator);
    vm.expectRevert('Pausable: not paused');
    ksRole.setZohar3(address(1));
  }
}
