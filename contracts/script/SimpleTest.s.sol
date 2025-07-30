// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";

contract SimpleTest is Script {
    function run() external {
        console.log("Testing current contract...");

        // Test the current deployed contract
        address vault = 0x42ff57a358864c6EECe4fBe26c9362E74c179475;
        console.log("Vault address:", vault);

        // Check if contract exists
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(vault)
        }
        console.log("Contract code size:", codeSize);

        if (codeSize > 0) {
            console.log("✅ Contract exists on chain");
        } else {
            console.log("❌ Contract does not exist");
        }
    }
}
