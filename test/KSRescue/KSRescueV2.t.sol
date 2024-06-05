// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IERC721} from '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import {IERC1155} from '@openzeppelin/contracts/token/ERC1155/IERC1155.sol';

import {MockKSRescueV2} from '../mocks/MockKSRescueV2.sol';
import {MockERC721} from '../mocks/MockERC721.sol';
import {MockERC1155} from '../mocks/MockERC1155.sol';
import {KSRescueTest} from 'test/KSRescue/KSRescue.t.sol';

contract KSRescueV2Test is KSRescueTest {
  MockERC721 nftToken;
  MockERC1155 erc1155Token;
  MockKSRescueV2 ksRescueV2;

  function setUp() public virtual override {
    super.setUp();

    vm.startPrank(owner);
    ksRescueV2 = new MockKSRescueV2();
    vm.stopPrank();

    vm.startPrank(operator);
    nftToken = new MockERC721('My NFT', 'CT');
    nftToken.mint(address(ksRescueV2));
    nftToken.mint(address(ksRescueV2));
    nftToken.mint(address(ksRescue));
    nftToken.mint(address(ksRescueV2));

    erc1155Token = new MockERC1155('My URI for ERC1155');
    erc1155Token.mint(address(ksRescueV2), 1000);
    erc1155Token.mint(address(ksRescueV2), 500);
    erc1155Token.mint(operator, 1000);
    erc1155Token.mint(address(ksRescueV2), 1000);
    vm.stopPrank();
  }

  function testRevertInvalidRoleERC721() public {
    vm.startPrank(operator);
    vm.expectRevert('Ownable: caller is not the owner');
    uint256[] memory numbers = new uint256[](2);
    numbers[0] = 0;
    ksRescueV2.rescueBatchERC721(address(nftToken), numbers, operator);
  }

  function testRescueERC721() public {
    vm.startPrank(owner);
    uint256[] memory numbers = new uint256[](2);
    numbers[0] = 0;
    numbers[1] = 3;
    ksRescueV2.rescueBatchERC721(address(nftToken), numbers, guardian);
    assertEq(IERC721(nftToken).ownerOf(0), guardian);
    assertEq(IERC721(nftToken).ownerOf(1), address(ksRescueV2));
    assertEq(IERC721(nftToken).ownerOf(3), guardian);
  }

  function testRevertInvalidRoleERC1155() public {
    vm.startPrank(operator);
    vm.expectRevert('Ownable: caller is not the owner');
    uint256[] memory ids = new uint256[](1);
    ids[0] = 0;
    uint256[] memory amounts = new uint256[](1);
    amounts[0] = 100;
    ksRescueV2.rescueBatchERC1155(address(nftToken), ids, amounts, '', operator);
  }

  function testRescueERC1155() public {
    vm.startPrank(owner);
    uint256[] memory ids = new uint256[](3);
    ids[0] = 0;
    ids[1] = 1;
    ids[2] = 3;
    uint256[] memory amounts = new uint256[](3);
    amounts[0] = 100;
    amounts[1] = 0;
    amounts[2] = 200;
    ksRescueV2.rescueBatchERC1155(address(erc1155Token), ids, amounts, '', guardian);
    assertEq(IERC1155(erc1155Token).balanceOf(guardian, 0), 100);
    assertEq(IERC1155(erc1155Token).balanceOf(guardian, 1), 500);
    assertEq(IERC1155(erc1155Token).balanceOf(guardian, 3), 200);
  }
}
