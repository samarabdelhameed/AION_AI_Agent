// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/AIONVault.sol";

contract AIONVaultTest is Test {
    AIONVault vault;
    address user = address(0xBEEF);

    function setUp() public {
        vault = new AIONVault();
        vm.deal(user, 10 ether); // ندي المستخدم رصيد أولي
    }

    function testDepositIncreasesBalance() public {
        vm.prank(user);
        vault.deposit{value: 1 ether}();
        assertEq(vault.balances(user), 1 ether);
    }

    function testWithdrawReducesBalance() public {
        vm.prank(user);
        vault.deposit{value: 2 ether}();

        vm.prank(user);
        vault.withdraw(1 ether);

        assertEq(vault.balances(user), 1 ether);
    }

    function test_RevertWhen_WithdrawMoreThanBalance() public {
        vm.prank(user);
        vault.deposit{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert("Insufficient funds");
        vault.withdraw(2 ether); // هيترفض لأنه أكتر من الرصيد
    }

    function testBalanceOfReturnsCorrectValue() public {
        vm.prank(user);
        vault.deposit{value: 1.5 ether}();
        uint256 balance = vault.balanceOf(user);
        assertEq(balance, 1.5 ether);
    }
}
