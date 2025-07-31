// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/AIONVault.sol";
import "../src/strategies/StrategyVenus.sol";

contract TestCompleteScenario is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Starting Complete Test Scenario");
        console.log("Deployer:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy Strategy
        address vBNBAddress = 0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7;
        StrategyVenus strategy = new StrategyVenus(vBNBAddress);
        console.log("Strategy deployed at:", address(strategy));

        // 2. Deploy Vault with low minYieldClaim
        AIONVault vault = new AIONVault(0.01 ether, 0.0001 ether);
        console.log("Vault deployed at:", address(vault));

        // 3. Set AI Agent
        vault.setAIAgent(deployer);
        console.log("AI Agent set");

        // 4. Set Strategy
        vault.setStrategy(address(strategy));
        console.log("Strategy linked");

        // 5. Initialize Strategy
        strategy.initialize(address(vault), address(0));
        console.log("Strategy initialized");

        vm.stopBroadcast();

        // 6. Test Deposit
        vm.deal(deployer, 1 ether);
        vm.prank(deployer);
        vault.deposit{value: 0.01 ether}();
        console.log("Deposit successful");

        // 7. Check Balance
        uint256 balance = vault.balances(deployer);
        console.log("User balance:", balance);

        // 8. Check Yield
        uint256 yield = strategy.getYield(deployer);
        console.log("Available yield:", yield);

        // 9. Test Claim Yield
        vm.prank(deployer);
        vault.claimYield();
        console.log("Yield claimed successfully");

        // 10. Test Withdraw All
        vm.prank(deployer);
        vault.withdrawAll();
        console.log("Withdraw all successful");

        // 11. Test Emergency Withdraw (as owner)
        vm.deal(deployer, 0.01 ether);
        vm.prank(deployer);
        vault.deposit{value: 0.01 ether}();

        vm.prank(deployer);
        vault.emergencyWithdraw();
        console.log("Emergency withdraw successful");

        // 12. Test Pause/Unpause
        vm.prank(deployer);
        vault.pause();
        console.log("Vault paused");

        vm.prank(deployer);
        vault.unpause();
        console.log("Vault unpaused");

        // 13. Test Set Min Deposit
        vm.prank(deployer);
        vault.setMinDepositBNB(5); // 0.005 BNB
        console.log("Min deposit updated");

        // 14. Test Set Min Yield Claim
        vm.prank(deployer);
        vault.setMinYieldClaimBNB(1); // 0.0001 BNB
        console.log("Min yield claim updated");

        console.log("ALL TESTS PASSED! Ready for deployment.");
    }
}
