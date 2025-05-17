// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/AIONVault.sol";

contract DeployAIONVault is Script {
    function run() external {
        // نحمل الـ PRIVATE_KEY من .env باستخدام Forge Std
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // نبدأ البث باستخدام المفتاح الخاص
        vm.startBroadcast(deployerPrivateKey);

        // ننشر العقد
        new AIONVault();

        // نوقف البث
        vm.stopBroadcast();
    }
}
