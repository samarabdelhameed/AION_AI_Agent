// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";

contract SimpleDeposit is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Send 0.001 BNB to test
        payable(0x2A7DF06B1cA57030Dc6F7D9E0bb43475423Fd6A7).call{
            value: 0.001 ether
        }("");

        vm.stopBroadcast();

        console.log("Test deposit sent!");
    }
}
