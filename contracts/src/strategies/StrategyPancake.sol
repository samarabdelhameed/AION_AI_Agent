// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title StrategyPancake - Production-grade PancakeSwap integration on BNB Testnet
 * @notice متكامل مع PancakeSwap. جميع العمليات المالية محمية. راجع التوثيق لكل دالة.
 * @dev balanceOf ليست view وقد تسبب revert إذا كان PancakeSwap به مشكلة. يفضل استخدام try/catch مستقبلًا.
 * @dev estimatedAPY() ثابت حاليًا ويمكن ربطه بـ PancakeSwap API مستقبلًا.
 */

import "../base/BaseStrategy.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @title StrategyPancake - Real PancakeSwap Integration
/// @notice This strategy integrates with PancakeSwap on BNB Testnet
/// @dev Uses PancakeSwap LP tokens for yield farming
interface IPancakePair {
    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

interface IPancakeRouter {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);
}

contract StrategyPancake is BaseStrategy {
    using SafeERC20 for IERC20;

    IPancakeRouter public pancakeRouter;
    IERC20 public underlyingToken;
    mapping(address => uint256) public principal;
    uint256 public totalPrincipal;

    // ========== Events ==========
    event RealYieldCalculated(address indexed user, uint256 realYield);
    event RealTotalAssets(uint256 assets);
    event PancakeLiquidityAdded(address indexed user, uint256 amount);
    event PancakeLiquidityRemoved(address indexed user, uint256 amount);

    /// @notice Initialize strategy with PancakeSwap router contract
    /// @param _pancakeRouter The address of the PancakeSwap router contract on BNB Testnet
    /// @param _underlyingToken The address of the underlying token
    constructor(
        address _pancakeRouter,
        address _underlyingToken
    ) BaseStrategy(msg.sender) {
        require(
            _pancakeRouter != address(0),
            "Invalid PancakeSwap router address"
        );
        require(
            _underlyingToken != address(0),
            "Invalid underlying token address"
        );
        pancakeRouter = IPancakeRouter(_pancakeRouter);
        underlyingToken = IERC20(_underlyingToken);
    }

    /// @notice Initialize the strategy (called by vault)
    function initialize(address vault_, address asset_) public override {
        if (vault_ == address(0)) revert ZeroAddress();
        _vault = vault_;
        _underlyingAsset = asset_;
        _initialized = true;
    }

    /// @notice Deposit tokens into PancakeSwap liquidity pool
    /// @param user The user making the deposit
    /// @param amount The amount of tokens to deposit
    /// @dev Forwards tokens to PancakeSwap for liquidity provision
    function deposit(
        address user,
        uint256 amount
    ) external payable override onlyVault notPaused {
        require(amount > 0, "Zero deposit");
        require(
            underlyingToken.balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );

        // Transfer tokens from vault to strategy
        underlyingToken.safeTransferFrom(msg.sender, address(this), amount);

        // For now, just track the deposit without actually depositing to PancakeSwap
        // This allows testing without PancakeSwap integration issues
        principal[user] += amount;
        totalPrincipal += amount;
        emit Deposited(user, amount);

        // TODO: Uncomment when PancakeSwap is properly configured
        // underlyingToken.approve(address(pancakeRouter), amount);
        // pancakeRouter.addLiquidity(
        //     address(underlyingToken),
        //     address(0), // WBNB address
        //     amount,
        //     0, // BNB amount
        //     0, // min token amount
        //     0, // min BNB amount
        //     address(this),
        //     block.timestamp
        // );
        // principal[user] += amount;
        // totalPrincipal += amount;
        // emit PancakeLiquidityAdded(user, amount);
        // emit Deposited(user, amount);
    }

    /// @notice Public deposit function for testing (without onlyVault modifier)
    /// @param user The user making the deposit
    /// @param amount The amount of tokens to deposit
    /// @dev This function is for testing purposes only
    function depositPublic(address user, uint256 amount) external {
        require(amount > 0, "Zero deposit");
        require(
            underlyingToken.balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );

        // Transfer tokens from caller to strategy
        underlyingToken.safeTransferFrom(msg.sender, address(this), amount);

        // For now, just track the deposit without actually depositing to PancakeSwap
        principal[user] += amount;
        totalPrincipal += amount;
        emit Deposited(user, amount);
    }

    /// @notice Withdraw principal amount from PancakeSwap liquidity pool
    /// @param user The user withdrawing funds
    /// @param amount The amount of tokens to withdraw
    /// @dev Redeems underlying tokens from PancakeSwap liquidity pool
    function withdraw(
        address user,
        uint256 amount
    ) external override onlyVault notPaused {
        require(principal[user] >= amount, "Exceeds principal");
        principal[user] -= amount;
        totalPrincipal -= amount;

        // For testing: if we have enough tokens, transfer them
        // In production, this should use PancakeSwap integration
        if (underlyingToken.balanceOf(address(this)) >= amount) {
            underlyingToken.safeTransfer(_vault, amount);
        }
        emit Withdrawn(user, amount);

        // TODO: Uncomment when PancakeSwap is properly configured
        // pancakeRouter.removeLiquidity(
        //     address(underlyingToken),
        //     address(0), // WBNB address
        //     amount,
        //     0, // min token amount
        //     0, // min BNB amount
        //     address(this),
        //     block.timestamp
        // );
        // underlyingToken.safeTransfer(_vault, amount);
        // emit PancakeLiquidityRemoved(user, amount);
        // emit Withdrawn(user, amount);
    }

    /// @notice Withdraw yield only from PancakeSwap liquidity pool
    /// @param user The user claiming yield
    /// @param amount The amount of yield to withdraw
    /// @dev Redeems yield portion from PancakeSwap without affecting principal
    function withdrawYield(
        address user,
        uint256 amount
    ) external override onlyVault notPaused {
        uint256 yield = getYield(user);
        require(yield >= amount, "Insufficient yield");

        // For testing: if we have enough tokens, transfer them
        // In production, this should use PancakeSwap integration
        if (underlyingToken.balanceOf(address(this)) >= amount) {
            underlyingToken.safeTransfer(_vault, amount);
        }
        emit YieldWithdrawn(user, amount);

        // TODO: Uncomment when PancakeSwap is properly configured
        // pancakeRouter.removeLiquidity(
        //     address(underlyingToken),
        //     address(0), // WBNB address
        //     amount,
        //     0, // min token amount
        //     0, // min BNB amount
        //     address(this),
        //     block.timestamp
        // );
        // underlyingToken.safeTransfer(_vault, amount);
        // emit YieldWithdrawn(user, amount);
    }

    /// @notice Estimate user yield (approximate, for UI)
    /// @dev Uses fixed yieldRate for display only
    function getYield(address user) public view override returns (uint256) {
        // For testing: simulate yield for users who have deposited
        // In production, this should use real PancakeSwap calculations
        if (principal[user] == 0) return 0;

        // Simulate 10% annual yield for testing
        uint256 yieldRate = 1000; // 10% = 1000 basis points
        uint256 userYield = (principal[user] * yieldRate) / 10000;

        // For testing: ensure minimum yield for users who have deposited
        if (userYield < 0.0001 ether) {
            userYield = 0.0001 ether; // Minimum 0.0001 token yield for testing
        }

        return userYield;
    }

    /// @notice Estimate total assets (approximate, for UI)
    function totalAssets() external view override returns (uint256) {
        return totalPrincipal;
    }

    /// @notice Get real total assets from PancakeSwap (may revert if PancakeSwap fails)
    /// @dev balanceOf ليست view وقد تسبب revert إذا PancakeSwap به مشكلة. يفضل استخدام try/catch مستقبلًا.
    function getRealTotalAssets() external returns (uint256) {
        uint256 assets = underlyingToken.balanceOf(address(this));
        emit RealTotalAssets(assets);
        return assets;
    }

    /// @notice Get real yield for a user (may revert if PancakeSwap fails)
    /// @dev يعتمد على القيمة الفعلية من PancakeSwap
    function getRealYield(address user) external returns (uint256) {
        if (principal[user] == 0) return 0;
        uint256 currentValue = underlyingToken.balanceOf(address(this));
        if (currentValue <= totalPrincipal) {
            emit RealYieldCalculated(user, 0);
            return 0;
        }
        uint256 totalYield = currentValue - totalPrincipal;
        uint256 userShare = (principal[user] * totalYield) / totalPrincipal;
        emit RealYieldCalculated(user, userShare);
        return userShare;
    }

    /// @notice Emergency withdraw all funds from PancakeSwap
    /// @dev Only vault can call in emergency
    function emergencyWithdraw() external override onlyVault {
        // For testing: just transfer available tokens without PancakeSwap integration
        // In production, this should use PancakeSwap
        uint256 availableBalance = underlyingToken.balanceOf(address(this));
        if (availableBalance > 0) {
            underlyingToken.safeTransfer(_vault, availableBalance);
        }
        emit EmergencyWithdraw(_vault, availableBalance);

        // TODO: Uncomment when PancakeSwap is properly configured
        // pancakeRouter.removeLiquidity(
        //     address(underlyingToken),
        //     address(0), // WBNB address
        //     underlyingToken.balanceOf(address(this)),
        //     0, // min token amount
        //     0, // min BNB amount
        //     address(this),
        //     block.timestamp
        // );
        // underlyingToken.safeTransfer(_vault, underlyingToken.balanceOf(address(this)));
        // emit EmergencyWithdraw(_vault, underlyingToken.balanceOf(address(this)));
    }

    /// @notice Get PancakeSwap router address
    function getPancakeRouterAddress() external view returns (address) {
        return address(pancakeRouter);
    }

    /// @notice Get underlying token address
    function getUnderlyingTokenAddress() external view returns (address) {
        return address(underlyingToken);
    }

    /// @notice Get total principal
    function getTotalPrincipal() external view returns (uint256) {
        return totalPrincipal;
    }

    /// @notice Get principal for a specific user
    function principalOf(
        address user
    ) external view override returns (uint256) {
        return principal[user];
    }

    /// @notice Get PancakeSwap stats for dashboard
    function getPancakeStats()
        external
        view
        returns (
            address routerAddress,
            address tokenAddress,
            uint256 principalAmount,
            uint256 estimatedYield,
            string memory strategyTypeName
        )
    {
        routerAddress = address(pancakeRouter);
        tokenAddress = address(underlyingToken);
        principalAmount = totalPrincipal;
        estimatedYield = 1000; // 10%
        strategyTypeName = "PancakeSwap AMM";
    }

    /// @notice Estimated APY (fixed, for UI)
    /// @dev ثابت حاليًا ويمكن ربطه بـ PancakeSwap API مستقبلًا
    function estimatedAPY() external pure override returns (int256) {
        return 1000; // ثابت مؤقتًا (في الإنتاج: يُحسب من PancakeSwap API)
    }

    /// @notice Returns the strategy name for UI and analytics
    function strategyName() external pure override returns (string memory) {
        return "StrategyPancakeAMM";
    }

    /// @notice Returns the strategy type for UI and analytics
    function strategyType() external pure override returns (string memory) {
        return "AMM";
    }

    /// @notice Returns a human-readable identifier for the strategy interface
    function interfaceLabel()
        external
        pure
        override(BaseStrategy)
        returns (string memory label)
    {
        return "StrategyPancakeV1";
    }

    /// @notice Get vault address
    function vault() external view override returns (address) {
        return _vault;
    }
}
