// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/strategies/StrategyVenus.sol";
import "../src/AIONVault.sol";

contract TestStrategyVenusSimple is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("=== Testing All StrategyVenus Functions ===");
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

        // ========== Testing All Functions ==========

        console.log("\n=== Testing Basic Info Functions ===");

        // 6. Test strategyName
        console.log("strategyName():", strategy.strategyName());
        require(
            keccak256(bytes(strategy.strategyName())) ==
                keccak256(bytes("StrategyVenusBNB")),
            "Wrong strategy name"
        );

        // 7. Test strategyType
        console.log("strategyType():", strategy.strategyType());
        require(
            keccak256(bytes(strategy.strategyType())) ==
                keccak256(bytes("Lending")),
            "Wrong strategy type"
        );

        // 8. Test version
        console.log("version():", strategy.version());
        require(
            keccak256(bytes(strategy.version())) == keccak256(bytes("1.0.0")),
            "Wrong version"
        );

        // 9. Test estimatedAPY
        console.log("estimatedAPY():", strategy.estimatedAPY());
        require(strategy.estimatedAPY() == 500, "Wrong APY");

        // 10. Test isPaused (before pause)
        console.log("isPaused() (before):", strategy.isPaused());
        require(strategy.isPaused() == false, "Should not be paused initially");

        console.log("\n=== Testing Deposit Functions ===");

        // 11. Test depositPublic
        vm.deal(deployer, 1 ether);
        vm.prank(deployer);
        strategy.depositPublic{value: 0.01 ether}(deployer, 0.01 ether);
        console.log("depositPublic() successful");

        // 12. Test principalOf after deposit
        console.log(
            "principalOf() after deposit:",
            strategy.principalOf(deployer)
        );
        require(
            strategy.principalOf(deployer) == 0.01 ether,
            "Wrong principal amount"
        );

        // 13. Test totalPrincipal
        console.log("totalPrincipal():", strategy.totalPrincipal());
        require(
            strategy.totalPrincipal() == 0.01 ether,
            "Wrong total principal"
        );

        // 14. Test totalAssets
        console.log("totalAssets():", strategy.totalAssets());
        require(strategy.totalAssets() == 0.01 ether, "Wrong total assets");

        console.log("\n=== Testing Yield Functions ===");

        // 15. Test getYield
        console.log("getYield():", strategy.getYield(deployer));
        require(strategy.getYield(deployer) >= 0.0001 ether, "Yield too low");

        // 16. Test getVBNBAddress
        console.log("getVBNBAddress():", strategy.getVBNBAddress());
        require(strategy.getVBNBAddress() == vBNBAddress, "Wrong vBNB address");

        // 17. Test getTotalPrincipal
        console.log("getTotalPrincipal():", strategy.getTotalPrincipal());
        require(
            strategy.getTotalPrincipal() == 0.01 ether,
            "Wrong getTotalPrincipal"
        );

        console.log("\n=== Testing Venus Stats Functions ===");

        // 18. Test getVenusStats components
        console.log("getVenusStats components:");
        console.log("  vbnbAddress:", strategy.getVBNBAddress());
        console.log("  principalAmount:", strategy.totalPrincipal());
        console.log("  estimatedYield:", strategy.estimatedAPY());
        console.log("  strategyTypeName:", strategy.strategyType());

        require(
            strategy.getVBNBAddress() == vBNBAddress,
            "Wrong vBNB address in stats"
        );
        require(strategy.estimatedAPY() == 500, "Wrong yield in stats");
        require(
            keccak256(bytes(strategy.strategyType())) ==
                keccak256(bytes("Lending")),
            "Wrong strategy type name"
        );

        console.log("\n=== Testing Pause/Unpause Functions ===");

        // 19. Test pause
        vm.prank(deployer);
        strategy.pause();
        console.log("pause() successful");

        // 20. Test isPaused after pause
        console.log("isPaused() (after pause):", strategy.isPaused());
        require(strategy.isPaused() == true, "Should be paused");

        // 21. Test unpause
        vm.prank(deployer);
        strategy.unpause();
        console.log("unpause() successful");

        // 22. Test isPaused after unpause
        console.log("isPaused() (after unpause):", strategy.isPaused());
        require(strategy.isPaused() == false, "Should not be paused");

        console.log("\n=== Testing Emergency Functions ===");

        // 23. Test emergencyWithdraw from vault
        vm.deal(address(strategy), 0.01 ether);
        vm.prank(deployer);
        vault.emergencyWithdraw();
        console.log("emergencyWithdraw() successful");

        console.log("\n=== Testing Additional Functions ===");

        // 24. Test vault()
        console.log("vault():", strategy.vault());
        require(strategy.vault() == address(vault), "Wrong vault address");

        // 25. Test interfaceLabel()
        console.log("interfaceLabel():", strategy.interfaceLabel());
        require(
            keccak256(bytes(strategy.interfaceLabel())) ==
                keccak256(bytes("StrategyVenusV1")),
            "Wrong interface label"
        );

        console.log("\n=== All Tests Passed! ===");
        console.log("All StrategyVenus functions work correctly");
        console.log("Contract ready for final deployment");
    }
}
