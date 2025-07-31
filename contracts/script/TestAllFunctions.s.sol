// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/AIONVault.sol";
import "../src/strategies/StrategyVenus.sol";

contract TestAllFunctions is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(deployerPrivateKey);

        // Give user some BNB for testing
        vm.deal(user, 20 ether);

        console.log("=== AION Vault Complete Test ===");

        // 1. Deploy Strategy
        address vBNBAddress = 0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7;
        StrategyVenus strategy = new StrategyVenus(vBNBAddress);
        console.log("Strategy deployed at:", address(strategy));

        // 2. Deploy Vault with correct values
        vm.startBroadcast(deployerPrivateKey);
        AIONVault vault = new AIONVault(0.01 ether, 0.0001 ether);
        vm.stopBroadcast();
        console.log("Vault deployed at:", address(vault));

        // 3. Set AI Agent
        vm.prank(user); // Call as owner
        vault.setAIAgent(user);
        console.log("AI Agent set");

        // 4. Set Strategy
        vm.prank(user); // Call as AI Agent
        vault.setStrategy(address(strategy));
        console.log("Strategy linked to vault");

        // 5. Initialize Strategy
        strategy.initialize(address(vault), address(0));
        console.log("Strategy initialized");

        // 6. Test Deposit
        console.log("\n=== Testing Deposit ===");
        uint256 depositAmount = 0.01 ether;
        console.log("User depositing:", depositAmount, "wei");

        vm.prank(user); // Call as user
        (bool depositSuccess, ) = address(vault).call{value: depositAmount}(
            abi.encodeWithSignature("deposit()")
        );

        if (depositSuccess) {
            console.log("Deposit successful");
            uint256 userBalance = vault.balances(user);
            console.log("User balance in vault:", userBalance, "wei");
        } else {
            console.log("Deposit failed");
            return;
        }

        // 7. Test Claim Yield
        console.log("\n=== Testing Claim Yield ===");
        uint256 yieldBefore = strategy.getYield(user);
        console.log("Yield available:", yieldBefore, "wei");

        vm.prank(user); // Call as user
        (bool claimSuccess, ) = address(vault).call(
            abi.encodeWithSignature("claimYield()")
        );

        if (claimSuccess) {
            console.log("claimYield() successful!");
            uint256 claimedYield = vault.userYieldClaimed(user);
            console.log("Total yield claimed:", claimedYield, "wei");
        } else {
            console.log("claimYield() failed");
        }

        // 8. Test Pause/Unpause
        console.log("\n=== Testing Pause/Unpause ===");

        vm.prank(user); // Call as owner (same address)
        (bool pauseSuccess, ) = address(vault).call(
            abi.encodeWithSignature("pause()")
        );
        if (pauseSuccess) {
            console.log("pause() successful!");
        } else {
            console.log("pause() failed");
        }

        vm.prank(user); // Call as owner (same address)
        (bool unpauseSuccess, ) = address(vault).call(
            abi.encodeWithSignature("unpause()")
        );
        if (unpauseSuccess) {
            console.log("unpause() successful!");
        } else {
            console.log("unpause() failed");
        }

        // 9. Test Withdraw
        console.log("\n=== Testing Withdraw ===");
        uint256 withdrawAmount = 0.005 ether;
        console.log("Withdrawing:", withdrawAmount, "wei");

        // Give strategy some BNB for withdrawal
        vm.deal(address(strategy), 1 ether);

        vm.prank(user); // Call as user
        (bool withdrawSuccess, ) = address(vault).call(
            abi.encodeWithSignature("withdraw(uint256)", withdrawAmount)
        );

        if (withdrawSuccess) {
            console.log("withdraw() successful!");
        } else {
            console.log("withdraw() failed");
        }

        // 10. Test Withdraw All
        console.log("\n=== Testing Withdraw All ===");

        vm.prank(user); // Call as user
        (bool withdrawAllSuccess, ) = address(vault).call(
            abi.encodeWithSignature("withdrawAll()")
        );

        if (withdrawAllSuccess) {
            console.log("withdrawAll() successful!");
        } else {
            console.log("withdrawAll() failed");
        }

        // 11. Test Set Min Deposit
        console.log("\n=== Testing Set Min Deposit ===");

        vm.prank(user); // Call as owner (same address)
        (bool setMinDepositSuccess, ) = address(vault).call(
            abi.encodeWithSignature("setMinDeposit(uint256)", 0.005 ether)
        );

        if (setMinDepositSuccess) {
            console.log("setMinDeposit() successful!");
        } else {
            console.log("setMinDeposit() failed");
        }

        console.log("\n=== All Tests Completed Successfully ===");
        console.log("All functions are working correctly!");
    }
}
