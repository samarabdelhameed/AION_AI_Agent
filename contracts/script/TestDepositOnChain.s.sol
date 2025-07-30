// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/AIONVault.sol";

contract TestDepositOnChain is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Use the current deployed vault
        AIONVault vault = AIONVault(
            payable(0x42ff57a358864c6EECe4fBe26c9362E74c179475)
        );

        vm.startBroadcast(deployerPrivateKey);

        // Test deposit with 0.01 BNB
        vault.deposit{value: 0.01 ether}();

        vm.stopBroadcast();

        console.log("Deposit test completed!");
        console.log("Vault address:", address(vault));
    }
}
