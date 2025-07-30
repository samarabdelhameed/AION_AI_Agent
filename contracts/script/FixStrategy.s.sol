// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/strategies/StrategyVenus.sol";

contract FixStrategy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Fix the current strategy
        StrategyVenus strategy = StrategyVenus(
            0xC0a9cBc629c95DcB93E62C15dB6A01Cd95eA8Ac5
        );

        // Initialize strategy with vault
        strategy.initialize(
            0x42ff57a358864c6EECe4fBe26c9362E74c179475,
            address(0)
        );

        vm.stopBroadcast();

        console.log("Strategy fixed!");
        console.log("Strategy address:", address(strategy));
        console.log(
            "Vault address: 0x42ff57a358864c6EECe4fBe26c9362E74c179475"
        );
    }
}
