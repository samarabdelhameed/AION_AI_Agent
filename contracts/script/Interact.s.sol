// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/AIONVault.sol";

contract InteractScript is Script {
    address payable constant VAULT =
        payable(0x048AC9bE9365053c5569daa9860cBD5671869188);

    uint256 public depositAmount = 0.005 ether;
    uint256 public withdrawAmount = 0.002 ether;

    function run() external {
        vm.startBroadcast();

        AIONVault vault = AIONVault(VAULT);

        // Deposit
        try vault.deposit{value: depositAmount}() {
            console.log("Deposit of %s BNB successful", depositAmount);
        } catch {
            console.log("Deposit failed");
        }

        // Withdraw
        try vault.withdraw(withdrawAmount) {
            console.log("Withdrawal of %s BNB successful", withdrawAmount);
        } catch {
            console.log("Withdrawal failed");
        }

        vm.stopBroadcast();
    }
}
