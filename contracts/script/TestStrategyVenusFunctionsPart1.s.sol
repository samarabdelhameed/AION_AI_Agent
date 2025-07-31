// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/strategies/StrategyVenus.sol";
import "../src/AIONVault.sol";

contract TestStrategyVenusFunctionsPart1 is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("=== Testing StrategyVenus Functions Part 1 ===");
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

        // ========== Testing Basic Info Functions ==========

        console.log("\n=== Testing Basic Info Functions ===");

        // 6. Test strategyName
        string memory name = strategy.strategyName();
        console.log("strategyName():", name);
        require(
            keccak256(bytes(name)) == keccak256(bytes("StrategyVenusBNB")),
            "Wrong strategy name"
        );

        // 7. Test strategyType
        string memory type_ = strategy.strategyType();
        console.log("strategyType():", type_);
        require(
            keccak256(bytes(type_)) == keccak256(bytes("Lending")),
            "Wrong strategy type"
        );

        // 8. Test version
        string memory version = strategy.version();
        console.log("version():", version);
        require(
            keccak256(bytes(version)) == keccak256(bytes("1.0.0")),
            "Wrong version"
        );

        // 9. Test estimatedAPY
        int256 apy = strategy.estimatedAPY();
        console.log("estimatedAPY():", apy);
        require(apy == 500, "Wrong APY");

        // 10. Test isPaused (before pause)
        bool isPaused = strategy.isPaused();
        console.log("isPaused() (before):", isPaused);
        require(isPaused == false, "Should not be paused initially");

        console.log("\n=== Testing Deposit Functions ===");

        // 11. Test depositPublic
        vm.deal(deployer, 1 ether);
        vm.prank(deployer);
        strategy.depositPublic{value: 0.01 ether}(deployer, 0.01 ether);
        console.log("depositPublic() successful");

        // 12. Test principalOf after deposit
        uint256 principal = strategy.principalOf(deployer);
        console.log("principalOf() after deposit:", principal);
        require(principal == 0.01 ether, "Wrong principal amount");

        // 13. Test totalPrincipal
        uint256 totalPrincipal = strategy.totalPrincipal();
        console.log("totalPrincipal():", totalPrincipal);
        require(totalPrincipal == 0.01 ether, "Wrong total principal");

        // 14. Test totalAssets
        uint256 totalAssets = strategy.totalAssets();
        console.log("totalAssets():", totalAssets);
        require(totalAssets == 0.01 ether, "Wrong total assets");

        console.log("\n=== Testing Yield Functions ===");

        // 15. Test getYield
        uint256 yield = strategy.getYield(deployer);
        console.log("getYield():", yield);
        require(yield >= 0.0001 ether, "Yield too low");

        // 16. Test getVBNBAddress
        address vbnbAddr = strategy.getVBNBAddress();
        console.log("getVBNBAddress():", vbnbAddr);
        require(vbnbAddr == vBNBAddress, "Wrong vBNB address");

        // 17. Test getTotalPrincipal
        uint256 getTotalPrincipal = strategy.getTotalPrincipal();
        console.log("getTotalPrincipal():", getTotalPrincipal);
        require(getTotalPrincipal == 0.01 ether, "Wrong getTotalPrincipal");

        console.log("\n=== Part 1 Tests Passed! ===");
        console.log("Basic functions work correctly");
    }
}
