// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {BlacklistToken} from "../src/BlacklistToken.sol";

contract BlacklistTokenTest is Test {
    BlacklistToken public token;
    address public owner;
    address public user1 = address(0x123);
    address public user2 = address(0x456);
    address public blacklistedUser = address(0x789);

    function setUp() public {
        owner = address(this);
        token = new BlacklistToken();
        token.transfer(user1, 1000 ether);
    }

    function testInitialMint() public view {
        uint256 balance = token.balanceOf(address(this));
        assertEq(
            balance, token.INITIAL_SUPPLY() - 1000 ether, "Balance should be initial supply minus transferred amount"
        );
    }

    function testAddToBlacklist() public {
        vm.prank(owner);
        token.addToBlacklist(blacklistedUser);
        assertTrue(token.blacklist(blacklistedUser), "User should be blacklisted");
    }

    function testRemoveFromBlacklist() public {
        vm.prank(owner);
        token.addToBlacklist(blacklistedUser);
        token.removeFromBlacklist(blacklistedUser);
        assertTrue(!token.blacklist(blacklistedUser), "User should not be blacklisted");
    }

    function testTransferNotBlacklisted() public {
        vm.prank(user1);
        token.transfer(user2, 100 ether);
        assertEq(token.balanceOf(user2), 100 ether, "Transfer should succeed");
    }

    function testTransferFromBlacklisted() public {
        vm.prank(owner);
        token.addToBlacklist(user1);
        vm.prank(user1);
        vm.expectRevert("Address 'from' is blacklisted");
        token.transfer(user2, 100 ether);
    }

    function testTransferToBlacklisted() public {
        vm.prank(owner);
        token.addToBlacklist(user2);
        vm.prank(user1);
        vm.expectRevert("Address 'to' is blacklisted");
        token.transfer(user2, 100 ether);
    }

    function testTransferFromNotBlacklisted() public {
        uint256 amount = 500 ether;
        token.transfer(user1, 1000 ether);

        vm.prank(user1);
        token.approve(user2, amount);

        vm.prank(user2);
        bool success = token.transferFrom(user1, user2, amount);
        assertTrue(success, "transferFrom should succeed");
        assertEq(token.balanceOf(user2), amount, "user2 should have received the tokens");
        assertEq(token.balanceOf(user1), 2000 ether - amount, "user1 balance should decrease by the transferred amount");
    }

    function testTransferFromInBlacklisted() public {
        uint256 amount = 500 ether;
        token.transfer(user1, 1000 ether);
        token.approve(user2, amount);

        vm.prank(owner);
        token.addToBlacklist(user1);

        vm.prank(user2);
        vm.expectRevert("Address 'from' is blacklisted");
        token.transferFrom(user1, user2, amount);
    }

    function testApproveNotBlacklisted() public {
        uint256 amount = 500 ether;
        bool success = token.approve(user1, amount);
        assertTrue(success, "Approval should succeed");
        assertEq(token.allowance(address(this), user1), amount, "Allowance should be correctly set");
    }

    function testApproveBlacklisted() public {
        vm.prank(owner);
        token.addToBlacklist(user1);

        vm.expectRevert("Address 'to' is blacklisted");
        token.approve(user1, 500 ether);
    }
}
