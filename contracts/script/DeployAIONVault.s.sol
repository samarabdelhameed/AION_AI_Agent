// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/AIONVault.sol";
import "../src/strategies/StrategyVenus.sol";

contract DeployAIONVault is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // 1. عنوان vBNB على BSC Testnet
        address vBNBAddress = 0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7;
        console.log("Using vBNB address:", vBNBAddress);

        // 2. نشر استراتيجية Venus
        StrategyVenus strategy = new StrategyVenus(vBNBAddress);
        console.log("StrategyVenus deployed at:", address(strategy));

        // 3. نشر AIONVault بالقيم المطلوبة
        AIONVault vault = new AIONVault(0.01 ether, 0.001 ether);
        console.log("AIONVault deployed at:", address(vault));

        // 4. تعيين AI Agent (مطلوب قبل setStrategy)
        vault.setAIAgent(deployer);
        console.log("AI Agent set to:", deployer);

        // 5. تهيئة Strategy مع Vault
        strategy.initialize(address(vault), address(0)); // address(0) for BNB
        console.log("Strategy initialized with vault:", address(vault));

        // 6. ربط الاستراتيجية بالفولت
        vault.setStrategy(address(strategy));
        console.log("Strategy linked to vault");

        // 7. التحقق من الإعداد
        console.log("Verification:");
        console.log("   - Vault strategy:", address(vault.strategy()));
        console.log("   - Vault aiAgent:", address(vault.aiAgent()));

        vm.stopBroadcast();
    }
}
