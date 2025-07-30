// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/AIONVault.sol";

contract TestDeposit is Script {
    AIONVault public vault;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        // Use the latest deployed vault address
        vault = AIONVault(payable(0x2A7DF06B1cA57030Dc6F7D9E0bb43475423Fd6A7));

        vm.startBroadcast(deployerPrivateKey);

        // Test deposit with 0.01 BNB
        vault.deposit{value: 0.01 ether}();

        vm.stopBroadcast();

        console.log("Deposit successful!");
        console.log("Vault address:", address(vault));
        console.log("Deposited amount: 0.01 BNB");
    }
}
