// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IStrategy} from "./interfaces/IStrategy.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

contract StrategyAdapter is Ownable, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    struct StrategyInfo {
        address strategy;
        string name;
        uint8 riskLevel;
        uint256 apy;
        bool active;
        uint256 tvl;
    }

    struct UserPosition {
        address strategy;
        uint256 shares;
        uint256 depositedAt;
        uint256 lastHarvested;
    }

    IERC20 public immutable underlyingToken;

    StrategyInfo[] public strategies;
    mapping(address => UserPosition[]) public userPositions;
    mapping(address => uint256) public userTotalDeposits;

    uint256 public totalTVL;
    uint256 public totalUsers;

    uint256 public performanceFee = 200; // 2%
    uint256 public managementFee = 50; // 0.5%
    uint256 public lastFeeCollection;
    uint256 public constant FEE_INTERVAL = 1 days;
    uint256 public constant MAX_PERFORMANCE_FEE = 500;
    uint256 public constant MAX_MANAGEMENT_FEE = 200;

    event StrategyAdded(
        uint256 indexed strategyId,
        address strategy,
        string name
    );
    event StrategyRemoved(uint256 indexed strategyId, address strategy);
    event StrategyUpdated(
        uint256 indexed strategyId,
        address strategy,
        bool active
    );
    event UserDeposited(
        address indexed user,
        uint256 indexed strategyId,
        uint256 amount,
        uint256 shares
    );
    event UserWithdrawn(
        address indexed user,
        uint256 indexed strategyId,
        uint256 shares,
        uint256 amount
    );
    event Harvested(uint256 indexed strategyId, uint256 harvested);
    event FeesCollected(uint256 performanceFee, uint256 managementFee);

    constructor(address _underlyingToken, address _owner) Ownable(_owner) {
        require(_underlyingToken != address(0), "Invalid underlying token");
        require(_owner != address(0), "Invalid owner");

        underlyingToken = IERC20(_underlyingToken);
        lastFeeCollection = block.timestamp;
    }

    function addStrategy(
        address _strategy,
        string memory _name,
        uint8 _riskLevel
    ) external onlyOwner returns (uint256 strategyId) {
        require(_strategy != address(0), "Invalid strategy address");
        require(bytes(_name).length > 0, "Invalid strategy name");

        strategyId = strategies.length;
        strategies.push(
            StrategyInfo({
                strategy: _strategy,
                name: _name,
                riskLevel: _riskLevel,
                apy: 0,
                active: true,
                tvl: 0
            })
        );

        emit StrategyAdded(strategyId, _strategy, _name);
    }

    function removeStrategy(uint256 strategyId) external onlyOwner {
        require(strategyId < strategies.length, "Invalid strategy ID");
        require(strategies[strategyId].active, "Strategy already inactive");

        strategies[strategyId].active = false;
        emit StrategyRemoved(strategyId, strategies[strategyId].strategy);
    }

    function updateStrategy(
        uint256 strategyId,
        bool active
    ) external onlyOwner {
        require(strategyId < strategies.length, "Invalid strategy ID");
        strategies[strategyId].active = active;
        emit StrategyUpdated(
            strategyId,
            strategies[strategyId].strategy,
            active
        );
    }

    function deposit(
        uint256 strategyId,
        uint256 amount
    ) external nonReentrant whenNotPaused returns (uint256 shares) {
        require(strategyId < strategies.length, "Invalid strategy ID");
        require(strategies[strategyId].active, "Strategy not active");
        require(amount > 0, "Amount must be greater than 0");
        require(
            underlyingToken.balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );

        // Transfer tokens from user
        underlyingToken.safeTransferFrom(msg.sender, address(this), amount);

        // Approve strategy to spend tokens
        underlyingToken.approve(strategies[strategyId].strategy, 0);
        underlyingToken.approve(strategies[strategyId].strategy, amount);

        // Deposit into strategy
        IStrategy(strategies[strategyId].strategy).deposit(msg.sender, amount);
        shares = amount; // For now, 1:1 ratio

        // Update user position
        _addUserPosition(msg.sender, strategyId, shares);

        // Update TVL
        _updateStrategyTVL(strategyId);

        emit UserDeposited(msg.sender, strategyId, amount, shares);
    }

    function withdraw(
        uint256 strategyId,
        uint256 shares
    ) external nonReentrant returns (uint256 amount) {
        require(strategyId < strategies.length, "Invalid strategy ID");
        require(shares > 0, "Shares must be greater than 0");

        // Find user position
        uint256 positionIndex = _findUserPosition(msg.sender, strategyId);
        require(positionIndex != type(uint256).max, "No position found");
        require(
            userPositions[msg.sender][positionIndex].shares >= shares,
            "Insufficient shares"
        );

        // Withdraw from strategy
        IStrategy(strategies[strategyId].strategy).withdraw(msg.sender, shares);
        amount = shares; // For now, 1:1 ratio

        // Update user position
        _updateUserPosition(msg.sender, positionIndex, shares, false);

        // Transfer tokens to user
        underlyingToken.safeTransfer(msg.sender, amount);

        // Update TVL
        _updateStrategyTVL(strategyId);

        emit UserWithdrawn(msg.sender, strategyId, shares, amount);
    }

    function harvest(
        uint256 strategyId
    ) external nonReentrant returns (uint256 harvested) {
        require(strategyId < strategies.length, "Invalid strategy ID");
        require(strategies[strategyId].active, "Strategy not active");

        // Note: harvest() is not part of IStrategy interface, so we'll skip it for now
        harvested = 0;

        if (harvested > 0) {
            uint256 performanceFeeAmount = (harvested * performanceFee) / 10000;
            uint256 netHarvested = harvested - performanceFeeAmount;

            // Transfer performance fee to owner
            underlyingToken.safeTransfer(owner(), performanceFeeAmount);

            // Update TVL
            _updateStrategyTVL(strategyId);
        }

        emit Harvested(strategyId, harvested);
    }

    function harvestAll()
        external
        nonReentrant
        returns (uint256 totalHarvested)
    {
        for (uint256 i = 0; i < strategies.length; i++) {
            if (strategies[i].active) {
                // Note: harvest() is not part of IStrategy interface, so we'll skip it for now
                uint256 harvested = 0;
                if (harvested > 0) {
                    uint256 performanceFeeAmount = (harvested *
                        performanceFee) / 10000;
                    uint256 netHarvested = harvested - performanceFeeAmount;
                    totalHarvested += netHarvested;

                    // Transfer performance fee to owner
                    underlyingToken.safeTransfer(owner(), performanceFeeAmount);
                }
                _updateStrategyTVL(i);
            }
        }
    }

    function collectFees() external nonReentrant {
        require(
            block.timestamp >= lastFeeCollection + FEE_INTERVAL,
            "Too early to collect fees"
        );

        uint256 timeElapsed = block.timestamp - lastFeeCollection;
        uint256 managementFeeAmount = (totalTVL * managementFee * timeElapsed) /
            (365 days * 10000);

        if (managementFeeAmount > 0) {
            underlyingToken.safeTransfer(owner(), managementFeeAmount);
        }

        lastFeeCollection = block.timestamp;
        emit FeesCollected(0, managementFeeAmount);
    }

    function getUserPositions(
        address user
    ) external view returns (UserPosition[] memory) {
        return userPositions[user];
    }

    function getUserTotalDeposits(
        address user
    ) external view returns (uint256) {
        return userTotalDeposits[user];
    }

    function getStrategies() external view returns (StrategyInfo[] memory) {
        return strategies;
    }

    function getStrategyCount() external view returns (uint256) {
        return strategies.length;
    }

    function getTotalTVL() external view returns (uint256) {
        return totalTVL;
    }

    function updatePerformanceFee(uint256 newFee) external onlyOwner {
        require(newFee <= MAX_PERFORMANCE_FEE, "Fee too high");
        performanceFee = newFee;
    }

    function updateManagementFee(uint256 newFee) external onlyOwner {
        require(newFee <= MAX_MANAGEMENT_FEE, "Fee too high");
        managementFee = newFee;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function emergencyWithdraw(uint256 strategyId) external onlyOwner {
        require(strategyId < strategies.length, "Invalid strategy ID");
        IStrategy(strategies[strategyId].strategy).emergencyWithdraw();
        _updateStrategyTVL(strategyId);
    }

    function _addUserPosition(
        address user,
        uint256 strategyId,
        uint256 shares
    ) internal {
        userPositions[user].push(
            UserPosition({
                strategy: strategies[strategyId].strategy,
                shares: shares,
                depositedAt: block.timestamp,
                lastHarvested: block.timestamp
            })
        );

        userTotalDeposits[user] += shares;
        if (userPositions[user].length == 1) {
            totalUsers++;
        }
    }

    function _findUserPosition(
        address user,
        uint256 strategyId
    ) internal view returns (uint256) {
        for (uint256 i = 0; i < userPositions[user].length; i++) {
            if (
                userPositions[user][i].strategy ==
                strategies[strategyId].strategy
            ) {
                return i;
            }
        }
        return type(uint256).max;
    }

    function _updateUserPosition(
        address user,
        uint256 positionIndex,
        uint256 shares,
        bool isDeposit
    ) internal {
        if (isDeposit) {
            userPositions[user][positionIndex].shares += shares;
            userTotalDeposits[user] += shares;
        } else {
            userPositions[user][positionIndex].shares -= shares;
            userTotalDeposits[user] -= shares;

            if (userPositions[user][positionIndex].shares == 0) {
                // Remove position if shares become 0
                userPositions[user][positionIndex] = userPositions[user][
                    userPositions[user].length - 1
                ];
                userPositions[user].pop();
            }
        }
    }

    function _updateStrategyTVL(uint256 strategyId) internal {
        if (strategies[strategyId].active) {
            strategies[strategyId].tvl = IStrategy(
                strategies[strategyId].strategy
            ).totalAssets();
            strategies[strategyId].apy = uint256(
                IStrategy(strategies[strategyId].strategy).estimatedAPY()
            );

            // Update total TVL
            totalTVL = 0;
            for (uint256 i = 0; i < strategies.length; i++) {
                if (strategies[i].active) {
                    totalTVL += strategies[i].tvl;
                }
            }
        }
    }

    function getStrategyRecommendation(
        address user,
        uint256 riskTolerance
    ) external view returns (uint256) {
        require(
            riskTolerance >= 1 && riskTolerance <= 5,
            "Invalid risk tolerance"
        );

        uint256 bestStrategy = 0;
        uint256 bestScore = 0;

        for (uint256 i = 0; i < strategies.length; i++) {
            if (!strategies[i].active) continue;

            // Calculate score based on risk match and APY
            uint256 riskScore = 5 -
                abs(
                    int256(uint256(strategies[i].riskLevel)) -
                        int256(riskTolerance)
                );
            uint256 apyScore = strategies[i].apy / 100; // Normalize APY
            uint256 totalScore = riskScore + apyScore;

            if (totalScore > bestScore) {
                bestScore = totalScore;
                bestStrategy = i;
            }
        }

        return bestStrategy;
    }

    function abs(int256 x) internal pure returns (uint256) {
        return x >= 0 ? uint256(x) : uint256(-x);
    }
}
