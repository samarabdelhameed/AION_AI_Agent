// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/strategies/StrategyVenus.sol";
import "../src/AIONVault.sol";

contract TestStrategyVenusFunctionsPart2 is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("=== Testing StrategyVenus Functions Part 2 ===");
        console.log("Deployer:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy StrategyVenus
        address vBNBAddress = 0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7;
        StrategyVenus strategy = new StrategyVenus(vBNBAddress);
        console.log("StrategyVenus deployed at:", address(strategy));

        // 2. Deploy AIONVault
        AIONVault vault = new AIONVault(0.01 ether, 0.0001 ether);
        console.log("AIONVault deployed at:", address(vault));

        // 3. Set AI Agent
        vault.setAIAgent(deployer);
        console.log("AI Agent set");

        // 4. Link Strategy to vault
        vault.setStrategy(address(strategy));
        console.log("Strategy linked to vault");

        // 5. Initialize Strategy
        strategy.initialize(address(vault), address(0));
        console.log("Strategy initialized");

        vm.stopBroadcast();

        // ========== Testing Venus Stats Functions ==========

        console.log("\n=== Testing Venus Stats Functions ===");

        // 6. Test getVenusStats (simplified to avoid stack too deep)
        address vbnbAddress = strategy.getVBNBAddress();
        uint256 principalAmount = strategy.totalPrincipal();
        int256 estimatedYield = strategy.estimatedAPY();
        string memory strategyTypeName = strategy.strategyType();

        console.log("getVenusStats components:");
        console.log("  vbnbAddress:", vbnbAddress);
        console.log("  principalAmount:", principalAmount);
        console.log("  estimatedYield:", estimatedYield);
        console.log("  strategyTypeName:", strategyTypeName);

        require(vbnbAddress == vBNBAddress, "Wrong vBNB address in stats");
        require(estimatedYield == 500, "Wrong yield in stats");
        require(
            keccak256(bytes(strategyTypeName)) == keccak256(bytes("Lending")),
            "Wrong strategy type name"
        );

        console.log("\n=== Testing Pause/Unpause Functions ===");

        // 7. Test pause
        vm.prank(deployer);
        strategy.pause();
        console.log("pause() successful");

        // 8. Test isPaused after pause
        bool isPaused = strategy.isPaused();
        console.log("isPaused() (after pause):", isPaused);
        require(isPaused == true, "Should be paused");

        // 9. Test unpause
        vm.prank(deployer);
        strategy.unpause();
        console.log("unpause() successful");

        // 10. Test isPaused after unpause
        isPaused = strategy.isPaused();
        console.log("isPaused() (after unpause):", isPaused);
        require(isPaused == false, "Should not be paused");

        console.log("\n=== Testing Emergency Functions ===");

        // 11. Test emergencyWithdraw from vault
        vm.deal(address(strategy), 0.01 ether);
        vm.prank(deployer);
        vault.emergencyWithdraw();
        console.log("emergencyWithdraw() successful");

        console.log("\n=== Testing Additional Functions ===");

        // 12. Test vault()
        address vaultAddr = strategy.vault();
        console.log("vault():", vaultAddr);
        require(vaultAddr == address(vault), "Wrong vault address");

        // 13. Test interfaceLabel()
        string memory label = strategy.interfaceLabel();
        console.log("interfaceLabel():", label);
        require(
            keccak256(bytes(label)) == keccak256(bytes("StrategyVenusV1")),
            "Wrong interface label"
        );

        console.log("\n=== Part 2 Tests Passed! ===");
        console.log("Advanced functions work correctly");
        console.log("All StrategyVenus functions tested successfully!");
    }
}
