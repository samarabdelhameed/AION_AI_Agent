// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/AIONVault.sol";
import "../src/strategies/StrategyVenus.sol";

contract DeployAIONVault is Script {
    function run() external {
        // نبدأ البث بدون الحاجة لتحميل PRIVATE_KEY داخل الكود
        vm.startBroadcast();

        // عنوان vBNB على BNB Testnet
        address vBNBAddress = 0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7;

        // نشر StrategyVenus مع عنوان vBNB الحقيقي
        StrategyVenus strategy = new StrategyVenus(vBNBAddress);
        console.log("StrategyVenus deployed at:", address(strategy));

        // نشر AIONVault
        AIONVault vault = new AIONVault(0.01 ether, 0.001 ether);
        console.log("AIONVault deployed at:", address(vault));

        // تهيئة الاستراتيجية مع الفولت و BNB
        strategy.initialize(address(vault), address(0));
        console.log("Strategy initialized with vault:", address(vault));

        // نوقف البث
        vm.stopBroadcast();
    }
}
