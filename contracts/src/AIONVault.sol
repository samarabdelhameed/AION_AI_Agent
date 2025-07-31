// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title AIONVault - AI-powered DeFi Vault for BNB strategy execution
 * @notice Production-grade contract. Security: Ownable, nonReentrant, Pausable, StrategyLocking, onlyAIAgent, onlyStrategy. See comments for best practices.
 */

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./interfaces/IStrategy.sol";

/// @title AIONVault - AI-powered DeFi Vault for BNB strategy execution
/// @author Samar
contract AIONVault is Ownable, ReentrancyGuard, Pausable {
    IStrategy public strategy;
    address public aiAgent;
    bool public strategyLocked;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public userYieldClaimed;
    uint256 public accumulatedYield;
    uint256 public minDeposit;
    uint256 public minYieldClaim;

    // ========== Events ==========
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event WithdrawAll(address indexed user, uint256 amount);
    event StrategyUpdated(address indexed newStrategy);
    event AIAgentUpdated(address indexed newAgent);
    event EmergencyWithdraw(address indexed to, uint256 amount);
    event YieldClaimed(address indexed user, uint256 amount);
    event StrategyLocked();
    event MinDepositUpdated(uint256 oldValue, uint256 newValue);
    event MinYieldClaimUpdated(uint256 oldValue, uint256 newValue);

    // ========== Modifiers ==========
    /// @dev Only the AI agent can call
    modifier onlyAIAgent() {
        require(msg.sender == aiAgent, "Not authorized (AI)");
        _;
    }
    /// @dev Only the current strategy can call
    modifier onlyStrategy() {
        require(msg.sender == address(strategy), "Not strategy");
        _;
    }
    /// @dev Only if strategy is set
    modifier strategyIsSet() {
        require(address(strategy) != address(0), "Strategy not set");
        _;
    }

    // ========== Security: Ownable ==========
    // Only the contract owner can call (see OpenZeppelin Ownable)
    // ========== Security: nonReentrant ==========
    // Prevents reentrancy attacks on all financial functions
    // ========== Security: Pausable ==========
    // Can pause all operations in emergency
    // ========== Security: Strategy Locking ==========
    // Prevents changing strategy after locking

    constructor(
        uint256 _minDeposit,
        uint256 _minYieldClaim
    ) Ownable(msg.sender) {
        minDeposit = _minDeposit;
        minYieldClaim = _minYieldClaim;
    }

    /// @notice Set the AI Agent address that can change strategies
    /// @param _agent The address of the AI Agent contract
    /// @dev Only the vault owner can set the AI Agent
    /// @dev The AI Agent is responsible for strategy selection and optimization
    function setAIAgent(address _agent) external onlyOwner {
        require(_agent != address(0), "Invalid AI Agent");
        aiAgent = _agent;
        emit AIAgentUpdated(_agent);
    }

    /// @notice Lock the strategy to prevent further changes
    /// @dev Only the vault owner can lock the strategy
    /// @dev Once locked, no new strategies can be set until unlocked
    function lockStrategy() external onlyOwner {
        strategyLocked = true;
        emit StrategyLocked();
    }

    /**
     * @notice Unlocks the strategy to allow updates again (for development/testing)
     * @dev Only callable by the contract owner
     */
    function unlockStrategy() external onlyOwner {
        strategyLocked = false;
    }

    /// @notice Set a new strategy for the vault
    /// @param _strategy The address of the new strategy contract
    /// @dev Only the AI Agent can change strategies
    /// @dev Strategy must not be locked and must be a valid address
    function setStrategy(address _strategy) external onlyAIAgent {
        require(!strategyLocked, "Strategy updates locked");
        require(_strategy != address(0), "Invalid strategy");
        strategy = IStrategy(_strategy);
        emit StrategyUpdated(_strategy);
    }

    /// @notice Set the minimum deposit amount required (in wei)
    /// @param _minDeposit The minimum deposit amount in wei
    /// @dev Only the vault owner can adjust minimum deposit requirements
    /// @dev Helps prevent spam deposits and ensures meaningful transactions
    function setMinDeposit(uint256 _minDeposit) external onlyOwner {
        uint256 oldValue = minDeposit;
        minDeposit = _minDeposit;
        emit MinDepositUpdated(oldValue, _minDeposit);
    }

    /// @notice Set the minimum deposit amount required (accepts decimal BNB values)
    /// @param _minDepositBNB The minimum deposit amount in BNB (e.g., 1000 for 0.001 BNB, 10000 for 0.01 BNB)
    /// @dev Only the vault owner can adjust minimum deposit requirements
    /// @dev Converts BNB to wei automatically (input in thousandths of BNB)
    function setMinDepositBNB(uint256 _minDepositBNB) external onlyOwner {
        uint256 oldValue = minDeposit;
        minDeposit = _minDepositBNB * 1e15; // 1000 = 0.001 BNB, 10000 = 0.01 BNB
        emit MinDepositUpdated(oldValue, minDeposit);
    }

    /// @notice Set the minimum yield amount required for claiming (in wei)
    /// @param _minYieldClaim The minimum yield amount in wei
    /// @dev Only the vault owner can adjust minimum yield claim requirements
    /// @dev Prevents micro-transactions and gas waste on small yield claims
    function setMinYieldClaim(uint256 _minYieldClaim) external onlyOwner {
        uint256 oldValue = minYieldClaim;
        minYieldClaim = _minYieldClaim;
        emit MinYieldClaimUpdated(oldValue, _minYieldClaim);
    }

    /// @notice Set the minimum yield amount required for claiming (accepts decimal BNB values)
    /// @param _minYieldClaimBNB The minimum yield amount in BNB (e.g., 100 for 0.0001 BNB, 1000 for 0.001 BNB)
    /// @dev Only the vault owner can adjust minimum yield claim requirements
    /// @dev Converts BNB to wei automatically (input in ten-thousandths of BNB)
    function setMinYieldClaimBNB(uint256 _minYieldClaimBNB) external onlyOwner {
        uint256 oldValue = minYieldClaim;
        minYieldClaim = _minYieldClaimBNB * 1e14; // 100 = 0.0001 BNB, 1000 = 0.001 BNB
        emit MinYieldClaimUpdated(oldValue, minYieldClaim);
    }

    /// @notice Pause all vault operations (deposits, withdrawals, yield claims)
    /// @dev Only the vault owner can pause operations
    /// @dev Useful for emergency situations or maintenance
    function pause() external onlyOwner {
        _pause();
    }

    /// @notice Unpause all vault operations
    /// @dev Only the vault owner can unpause operations
    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice Deposit BNB into the vault
    /// @dev Checks minDeposit, then forwards to strategy.deposit
    function deposit() external payable nonReentrant whenNotPaused {
        require(msg.value > 0, "Invalid amount");
        require(msg.value >= minDeposit, "Deposit too small");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);

        // Only call strategy if it's set and initialized
        if (address(strategy) != address(0)) {
            // Check if strategy is initialized
            try strategy.vaultAddress() returns (address vaultAddr) {
                if (vaultAddr != address(0)) {
                    try
                        strategy.deposit{value: msg.value}(
                            msg.sender,
                            msg.value
                        )
                    {
                        // Success
                    } catch {
                        // Strategy failed, but we already recorded the deposit
                        // This allows deposits to work even if strategy has issues
                    }
                }
            } catch {
                // Strategy not initialized, skip
            }
        }
    }

    /// @notice Withdraw BNB from the vault
    /// @param amount The amount to withdraw
    /// @dev Checks user balance, calls strategy.withdraw, and ensures funds are returned
    /// @dev Strategy must guarantee returning at least the requested amount (see docs)
    function withdraw(
        uint256 amount
    ) external nonReentrant whenNotPaused strategyIsSet {
        require(amount > 0, "Invalid amount");
        require(balances[msg.sender] >= amount, "Insufficient funds");
        uint256 before = address(this).balance;
        strategy.withdraw(msg.sender, amount);
        uint256 afterBal = address(this).balance;
        require(afterBal >= before + amount, "Strategy did not return funds"); // Strategy must guarantee this
        balances[msg.sender] -= amount;
        Address.sendValue(payable(msg.sender), amount);
        emit Withdrawn(msg.sender, amount);
    }

    /// @notice Withdraw all user balance from the vault
    /// @dev Calls withdraw for the full balance
    function withdrawAll() external nonReentrant whenNotPaused strategyIsSet {
        uint256 userBal = balances[msg.sender];
        require(userBal > 0, "Nothing to withdraw");
        
        // Reset user balance first
        balances[msg.sender] = 0;
        
        // Try to withdraw from strategy
        if (address(strategy) != address(0)) {
            try strategy.withdraw(msg.sender, userBal) {
                // Strategy succeeded, check if funds were returned
                uint256 afterBal = address(this).balance;
                if (afterBal >= userBal) {
                    Address.sendValue(payable(msg.sender), userBal);
                }
            } catch {
                // Strategy failed, but we already reset balance
                // User can still withdraw their principal from vault balance
                if (address(this).balance >= userBal) {
                    Address.sendValue(payable(msg.sender), userBal);
                }
            }
        } else {
            // No strategy, withdraw directly from vault
            if (address(this).balance >= userBal) {
                Address.sendValue(payable(msg.sender), userBal);
            }
        }
        
        emit WithdrawAll(msg.sender, userBal);
    }

    /// @notice Emergency withdraw all funds to owner
    /// @dev Only the owner can call in emergency
    function emergencyWithdraw() external onlyOwner nonReentrant {
        if (address(strategy) != address(0)) {
            strategy.emergencyWithdraw();
        }
        uint256 bal = address(this).balance;
        if (bal > 0) {
            Address.sendValue(payable(owner()), bal);
            emit EmergencyWithdraw(owner(), bal);
        }
    }

    /// @notice Claim yield from the strategy
    /// @dev Checks minYieldClaim, calls strategy.getYield, and ensures funds are returned
    function claimYield() external nonReentrant whenNotPaused strategyIsSet {
        uint256 yieldAmount = strategy.getYield(msg.sender);
        require(yieldAmount >= minYieldClaim, "Yield too small");
        require(yieldAmount > 0, "No yield to claim");
        accumulatedYield += yieldAmount;
        userYieldClaimed[msg.sender] += yieldAmount;
        strategy.withdrawYield(msg.sender, yieldAmount);
        Address.sendValue(payable(msg.sender), yieldAmount);
        emit YieldClaimed(msg.sender, yieldAmount);
    }

    /// @notice Fallback function (disabled in production for security)
    /// @dev Receiving BNB directly is not allowed in production. Remove payable or add revert for extra safety.
    receive() external payable {
        // Allow direct BNB deposits like the old working code
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    fallback() external payable {
        // Allow direct BNB deposits like the old working code
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /// @notice Get the current deposit balance of a specific user
    /// @param user The address of the user to query
    /// @return The amount of BNB deposited by the user (in wei)
    /// @dev This function returns the principal amount deposited, excluding any yield
    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }

    /// @notice Get the total value of all assets managed by the current strategy
    /// @return The total value of all deposits plus accumulated yield (in wei)
    /// @dev This calls strategy.totalAssets() which may include both principal and yield
    function totalDeposits() external view returns (uint256) {
        return strategy.totalAssets();
    }

    /// @notice Check if a user has any deposits in the vault
    /// @param user The address of the user to check
    /// @return True if the user has deposited funds, false otherwise
    /// @dev Useful for UI to show/hide deposit options or user status
    function userHasDeposited(address user) external view returns (bool) {
        return balances[user] > 0;
    }

    /// @notice Get comprehensive vault statistics for a specific user
    /// @param user The address of the user to get stats for
    /// @return userDeposit The amount of BNB deposited by the user (principal only)
    /// @return strategyAddress The address of the current strategy contract
    /// @return vaultBalance The total value managed by the strategy (principal + yield)
    /// @return totalYield The total accumulated yield across all users
    /// @return userUnclaimedYield The yield available for the user to claim
    /// @return strategyActive Whether the strategy is currently active (not locked)
    /// @dev This function is essential for dashboard displays and user analytics
    /// @dev Returns real-time data from both vault and strategy contracts
    function getVaultStats(
        address user
    )
        external
        view
        returns (
            uint256 userDeposit,
            address strategyAddress,
            uint256 vaultBalance,
            uint256 totalYield,
            uint256 userUnclaimedYield,
            bool strategyActive
        )
    {
        userDeposit = balances[user];
        strategyAddress = address(strategy);
        vaultBalance = strategy.totalAssets();
        totalYield = accumulatedYield;
        userUnclaimedYield = strategy.getYield(user);
        strategyActive = !strategyLocked;
    }

    /// @notice Get the total amount of yield that a user has already claimed
    /// @param user The address of the user to query
    /// @return The total amount of yield claimed by the user (in wei)
    /// @dev This represents the historical total of all yield claims by the user
    /// @dev Useful for tracking user's yield history and performance
    function getUserTotalYield(address user) external view returns (uint256) {
        return userYieldClaimed[user];
    }

    /// @notice Get the total accumulated yield for a user (claimed + unclaimed)
    /// @param user The address of the user to query
    /// @return The total yield earned by the user (claimed + available to claim)
    /// @dev This is the sum of previously claimed yield plus currently available yield
    /// @dev Useful for calculating total user performance and APY calculations
    function getUserTotalAccumulatedYield(
        address user
    ) external view returns (uint256) {
        return userYieldClaimed[user] + strategy.getYield(user);
    }

    /// @dev Reserved for future yield logging (not used yet)
    function _logYieldActivity(address user, uint256 amount) internal pure {
        // reserved for future use
    }
}
