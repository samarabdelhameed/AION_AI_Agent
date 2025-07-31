// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/strategies/StrategyVenus.sol";
import "../src/AIONVault.sol";

contract TestStrategyVenusComplete is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("=== Starting Complete StrategyVenus Test ===");
        console.log("Deployer:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // 1. نشر StrategyVenus
        address vBNBAddress = 0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7;
        StrategyVenus strategy = new StrategyVenus(vBNBAddress);
        console.log("StrategyVenus deployed at:", address(strategy));

        // 2. Deploy AIONVault for testing
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

        // 6. Test depositPublic (for direct testing)
        vm.deal(deployer, 1 ether);
        vm.prank(deployer);
        strategy.depositPublic{value: 0.01 ether}(deployer, 0.01 ether);
        console.log("depositPublic successful");

        // 7. Test getYield
        uint256 yield = strategy.getYield(deployer);
        console.log("Available yield:", yield);

        // 8. Test principalOf
        uint256 principal = strategy.principalOf(deployer);
        console.log("User principal:", principal);

        // 9. Test totalPrincipal
        uint256 totalPrincipal = strategy.totalPrincipal();
        console.log("Total principal:", totalPrincipal);

        // 10. Test totalAssets
        uint256 totalAssets = strategy.totalAssets();
        console.log("Total assets:", totalAssets);

        // 11. Test estimatedAPY
        int256 apy = strategy.estimatedAPY();
        console.log("Estimated APY:", apy);

        // 12. Test strategyName
        string memory name = strategy.strategyName();
        console.log("Strategy name:", name);

        // 13. Test strategyType
        string memory type_ = strategy.strategyType();
        console.log("Strategy type:", type_);

        // 14. Test version
        string memory version = strategy.version();
        console.log("Strategy version:", version);

        // 15. Test isPaused
        bool isPaused = strategy.isPaused();
        console.log("Is paused:", isPaused);

        // 16. Test pause/unpause
        vm.prank(deployer);
        strategy.pause();
        console.log("Strategy paused");

        vm.prank(deployer);
        strategy.unpause();
        console.log("Strategy unpaused");

        // 17. Test emergencyWithdraw (called from vault)
        vm.deal(address(strategy), 0.01 ether); // Give balance to strategy
        vm.prank(deployer);
        vault.emergencyWithdraw();
        console.log("Emergency withdraw successful");

        console.log("=== All StrategyVenus tests passed! ===");
        console.log("Contract ready for deployment on BSC Testnet");
    }
}
