// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/AIONVault.sol";
import "../src/strategies/StrategyVenus.sol";

contract TestClaimYield is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(deployerPrivateKey);

        // Give user some BNB for testing
        vm.deal(user, 1 ether);

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy Strategy
        address vBNBAddress = 0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7;
        StrategyVenus strategy = new StrategyVenus(vBNBAddress);
        console.log("Strategy deployed at:", address(strategy));

        // 2. Deploy Vault
        AIONVault vault = new AIONVault(0.01 ether, 0.0001 ether);
        console.log("Vault deployed at:", address(vault));

        // 3. Set AI Agent
        vault.setAIAgent(user);
        console.log("AI Agent set");

        // 4. Set Strategy
        vault.setStrategy(address(strategy));
        console.log("Strategy linked to vault");

        // 5. Initialize Strategy
        strategy.initialize(address(vault), address(0));
        console.log("Strategy initialized");

        // 6. Simulate User Deposit
        uint256 depositAmount = 0.01 ether;

        console.log("User depositing:", depositAmount, "wei");
        console.log("User address:", user);
        console.log("User balance before deposit:", user.balance, "wei");

        // Simulate deposit
        (bool success, ) = address(vault).call{value: depositAmount}(
            abi.encodeWithSignature("deposit()")
        );

        if (success) {
            console.log("Deposit successful");

            // 7. Check user balance
            uint256 userBalance = vault.balances(user);
            console.log("User balance in vault:", userBalance, "wei");

            // 8. Check yield before claiming
            uint256 yieldBefore = strategy.getYield(user);
            console.log("Yield available:", yieldBefore, "wei");

            // 9. Simulate claimYield
            console.log("Attempting to claim yield...");

            (bool claimSuccess, bytes memory claimData) = address(vault).call(
                abi.encodeWithSignature("claimYield()")
            );

            if (claimSuccess) {
                console.log("claimYield() successful!");

                // 10. Check yield after claiming
                uint256 yieldAfter = strategy.getYield(user);
                console.log("Yield remaining:", yieldAfter, "wei");

                // 11. Check user's claimed yield
                uint256 claimedYield = vault.userYieldClaimed(user);
                console.log(
                    "Total yield claimed by user:",
                    claimedYield,
                    "wei"
                );
            } else {
                console.log("claimYield() failed");
                console.log("Error data:", string(claimData));
            }
        } else {
            console.log("Deposit failed");
        }

        vm.stopBroadcast();
    }
}
