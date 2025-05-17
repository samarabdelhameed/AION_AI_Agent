// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/AIONVault.sol";

contract AIONVaultTest is Test {
    AIONVault vault;
    address user = address(0xbeef);

    function setUp() public {
        vault = new AIONVault();
        vm.deal(user, 10 ether); // Give test user some BNB
    }

    function testDepositIncreasesBalance() public {
        vm.prank(user);
        vault.deposit{value: 1 ether}();

        uint256 balance = vault.balances(user);
        assertEq(balance, 1 ether);
    }

    function testWithdrawReducesBalance() public {
        vm.prank(user);
        vault.deposit{value: 2 ether}();

        vm.prank(user);
        vault.withdraw(1 ether);

        uint256 balance = vault.balances(user);
        assertEq(balance, 1 ether);
    }

    function testBalanceOfReturnsCorrectValue() public {
        vm.prank(user);
        vault.deposit{value: 1.5 ether}();

        uint256 result = vault.balanceOf(user);
        assertEq(result, 1.5 ether);
    }

    function test_RevertWhen_WithdrawMoreThanBalance() public {
        vm.prank(user);
        vault.deposit{value: 1 ether}();

        vm.expectRevert("Insufficient funds");
        vm.prank(user);
        vault.withdraw(2 ether);
    }
}
