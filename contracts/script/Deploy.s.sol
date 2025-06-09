// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/AIONVault.sol";

contract DeployAIONVault is Script {
    function run() external {
        // نبدأ البث بدون الحاجة لتحميل PRIVATE_KEY داخل الكود
        vm.startBroadcast();

        // ننشر العقد
        new AIONVault();

        // نوقف البث
        vm.stopBroadcast();
    }
}
