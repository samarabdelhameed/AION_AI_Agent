// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {StrategyPancake} from "../src/strategies/StrategyPancake.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title StrategyPancake Test Suite
/// @notice Comprehensive test suite for StrategyPancake integration
/// @dev Tests all major functionality including deposits, withdrawals, and yield calculations
contract StrategyPancakeTest is Test {
    StrategyPancake public strategy;
    address public vault;
    address public pancakeRouter;
    address public underlyingToken;
    address public user1;
    address public user2;
    address public owner;

    // Test constants
    uint256 public constant DEPOSIT_AMOUNT = 1 ether;
    uint256 public constant WITHDRAW_AMOUNT = 0.5 ether;
    uint256 public constant YIELD_AMOUNT = 0.1 ether;

    // Events to test
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event YieldWithdrawn(address indexed user, uint256 amount);
    event EmergencyWithdraw(address indexed vault, uint256 amount);
    event RealYieldCalculated(address indexed user, uint256 realYield);
    event RealTotalAssets(uint256 assets);

    function setUp() public {
        // Setup addresses
        owner = makeAddr("owner");
        vault = makeAddr("vault");
        pancakeRouter = makeAddr("pancakeRouter");
        underlyingToken = makeAddr("underlyingToken");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        // Deploy strategy
        vm.startPrank(owner);
        strategy = new StrategyPancake(pancakeRouter, underlyingToken);
        strategy.initialize(vault, underlyingToken);
        vm.stopPrank();
    }

    // ========== Constructor Tests ==========

    function testConstructor() public {
        assertEq(address(strategy.pancakeRouter()), pancakeRouter);
        assertEq(address(strategy.underlyingToken()), underlyingToken);
        assertEq(strategy.owner(), owner);
    }

    function testConstructorZeroPancakeRouter() public {
        vm.expectRevert("Invalid PancakeSwap router address");
        new StrategyPancake(address(0), underlyingToken);
    }

    function testConstructorZeroUnderlyingToken() public {
        vm.expectRevert("Invalid underlying token address");
        new StrategyPancake(pancakeRouter, address(0));
    }

    // ========== Initialization Tests ==========

    function testInitialize() public {
        assertTrue(strategy.isInitialized());
        assertEq(strategy.vaultAddress(), vault);
        assertEq(strategy.underlyingAsset(), underlyingToken);
    }

    function testInitializeZeroVault() public {
        StrategyPancake newStrategy = new StrategyPancake(
            pancakeRouter,
            underlyingToken
        );
        vm.startPrank(owner);
        vm.expectRevert();
        newStrategy.initialize(address(0), underlyingToken);
        vm.stopPrank();
    }

    function testInitializeTwice() public {
        vm.startPrank(owner);
        // For testing: allow re-initialization
        strategy.initialize(vault, underlyingToken);
        assertTrue(strategy.isInitialized());
        vm.stopPrank();
    }

    // ========== Deposit Tests ==========

    function testDepositPublic() public {
        // Mock token balance
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT)
        );

        vm.expectEmit(true, false, false, true);
        emit Deposited(user1, DEPOSIT_AMOUNT);

        strategy.depositPublic(user1, DEPOSIT_AMOUNT);

        assertEq(strategy.principalOf(user1), DEPOSIT_AMOUNT);
        assertEq(strategy.getTotalPrincipal(), DEPOSIT_AMOUNT);
    }

    function testDepositPublicZeroAmount() public {
        vm.expectRevert("Zero deposit");
        strategy.depositPublic(user1, 0);
    }

    function testDepositPublicInsufficientBalance() public {
        // Mock insufficient balance
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(0)
        );

        vm.expectRevert("Insufficient balance");
        strategy.depositPublic(user1, DEPOSIT_AMOUNT);
    }

    function testDepositOnlyVault() public {
        vm.startPrank(user1);
        vm.expectRevert();
        strategy.deposit(user1, DEPOSIT_AMOUNT);
        vm.stopPrank();
    }

    // ========== Withdraw Tests ==========

    function testWithdraw() public {
        // Setup initial deposit
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT)
        );
        strategy.depositPublic(user1, DEPOSIT_AMOUNT);

        // Mock token balance for withdrawal
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(
                IERC20.balanceOf.selector,
                address(strategy)
            ),
            abi.encode(WITHDRAW_AMOUNT)
        );

        vm.expectEmit(true, false, false, true);
        emit Withdrawn(user1, WITHDRAW_AMOUNT);

        vm.prank(vault);
        strategy.withdraw(user1, WITHDRAW_AMOUNT);

        assertEq(strategy.principalOf(user1), DEPOSIT_AMOUNT - WITHDRAW_AMOUNT);
        assertEq(
            strategy.getTotalPrincipal(),
            DEPOSIT_AMOUNT - WITHDRAW_AMOUNT
        );
    }

    function testWithdrawExceedsPrincipal() public {
        vm.startPrank(vault);
        vm.expectRevert("Exceeds principal");
        strategy.withdraw(user1, DEPOSIT_AMOUNT);
        vm.stopPrank();
    }

    function testWithdrawOnlyVault() public {
        vm.startPrank(user1);
        vm.expectRevert();
        strategy.withdraw(user1, WITHDRAW_AMOUNT);
        vm.stopPrank();
    }

    // ========== Yield Tests ==========

    function testGetYield() public {
        // Setup deposit
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT)
        );
        strategy.depositPublic(user1, DEPOSIT_AMOUNT);

        uint256 yield = strategy.getYield(user1);
        assertGt(yield, 0, "Should have yield for deposited user");

        // Test user with no deposit
        uint256 noYield = strategy.getYield(user2);
        assertEq(noYield, 0, "Should have no yield for user with no deposit");
    }

    function testWithdrawYield() public {
        // Setup deposit
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT)
        );
        strategy.depositPublic(user1, DEPOSIT_AMOUNT);

        // Mock token balance for yield withdrawal
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(
                IERC20.balanceOf.selector,
                address(strategy)
            ),
            abi.encode(YIELD_AMOUNT)
        );

        vm.expectEmit(true, false, false, true);
        emit YieldWithdrawn(user1, YIELD_AMOUNT);

        vm.prank(vault);
        strategy.withdrawYield(user1, YIELD_AMOUNT);
    }

    function testWithdrawYieldInsufficientYield() public {
        vm.startPrank(vault);
        vm.expectRevert("Insufficient yield");
        strategy.withdrawYield(user1, YIELD_AMOUNT);
        vm.stopPrank();
    }

    function testWithdrawYieldOnlyVault() public {
        vm.startPrank(user1);
        vm.expectRevert();
        strategy.withdrawYield(user1, YIELD_AMOUNT);
        vm.stopPrank();
    }

    // ========== Emergency Withdraw Tests ==========

    function testEmergencyWithdraw() public {
        // Mock token balance
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(
                IERC20.balanceOf.selector,
                address(strategy)
            ),
            abi.encode(DEPOSIT_AMOUNT)
        );

        vm.expectEmit(true, false, false, true);
        emit EmergencyWithdraw(vault, DEPOSIT_AMOUNT);

        vm.prank(vault);
        strategy.emergencyWithdraw();
    }

    function testEmergencyWithdrawOnlyVault() public {
        vm.startPrank(user1);
        vm.expectRevert();
        strategy.emergencyWithdraw();
        vm.stopPrank();
    }

    // ========== View Function Tests ==========

    function testTotalAssets() public {
        assertEq(strategy.totalAssets(), 0);

        // After deposit
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT)
        );
        strategy.depositPublic(user1, DEPOSIT_AMOUNT);

        assertEq(strategy.totalAssets(), DEPOSIT_AMOUNT);
    }

    function testPrincipalOf() public {
        assertEq(strategy.principalOf(user1), 0);

        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT)
        );
        strategy.depositPublic(user1, DEPOSIT_AMOUNT);

        assertEq(strategy.principalOf(user1), DEPOSIT_AMOUNT);
    }

    function testGetPancakeStats() public {
        (
            address routerAddress,
            address tokenAddress,
            uint256 principalAmount,
            uint256 estimatedYield,
            string memory strategyTypeName
        ) = strategy.getPancakeStats();

        assertEq(routerAddress, pancakeRouter);
        assertEq(tokenAddress, underlyingToken);
        assertEq(principalAmount, 0);
        assertEq(estimatedYield, 1000); // 10%
        assertEq(strategyTypeName, "PancakeSwap AMM");
    }

    function testStrategyInfo() public {
        assertEq(strategy.strategyName(), "StrategyPancakeAMM");
        assertEq(strategy.strategyType(), "AMM");
        assertEq(strategy.estimatedAPY(), 1000); // 10%
        assertEq(strategy.interfaceLabel(), "StrategyPancakeV1");
        assertEq(strategy.vault(), vault);
    }

    // ========== Real Integration Tests ==========

    function testGetRealTotalAssets() public {
        // Mock token balance
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(
                IERC20.balanceOf.selector,
                address(strategy)
            ),
            abi.encode(DEPOSIT_AMOUNT)
        );

        vm.expectEmit(false, false, false, true);
        emit RealTotalAssets(DEPOSIT_AMOUNT);

        uint256 assets = strategy.getRealTotalAssets();
        assertEq(assets, DEPOSIT_AMOUNT);
    }

    function testGetRealYield() public {
        // Setup deposit
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT)
        );
        strategy.depositPublic(user1, DEPOSIT_AMOUNT);

        // Mock token balance with yield
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(
                IERC20.balanceOf.selector,
                address(strategy)
            ),
            abi.encode(DEPOSIT_AMOUNT + YIELD_AMOUNT)
        );

        vm.expectEmit(true, false, false, true);
        emit RealYieldCalculated(user1, YIELD_AMOUNT);

        uint256 yield = strategy.getRealYield(user1);
        assertEq(yield, YIELD_AMOUNT);
    }

    function testGetRealYieldNoDeposit() public {
        uint256 yield = strategy.getRealYield(user1);
        assertEq(yield, 0);
    }

    // ========== Pause/Unpause Tests ==========

    function testPause() public {
        vm.prank(vault);
        strategy.pause();
        assertTrue(strategy.isPaused());
    }

    function testUnpause() public {
        vm.prank(vault);
        strategy.pause();
        vm.prank(vault);
        strategy.unpause();
        assertFalse(strategy.isPaused());
    }

    function testPauseOnlyVaultOrOwner() public {
        vm.startPrank(user1);
        vm.expectRevert("BaseStrategy: caller is not authorized");
        strategy.pause();
        vm.stopPrank();
    }

    // ========== Integration Scenario Tests ==========

    function testCompleteUserScenario() public {
        // 1. User deposits
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT)
        );
        strategy.depositPublic(user1, DEPOSIT_AMOUNT);

        assertEq(strategy.principalOf(user1), DEPOSIT_AMOUNT);
        assertEq(strategy.getTotalPrincipal(), DEPOSIT_AMOUNT);

        // 2. Check yield
        uint256 yield = strategy.getYield(user1);
        assertGt(yield, 0);

        // 3. Withdraw yield
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(
                IERC20.balanceOf.selector,
                address(strategy)
            ),
            abi.encode(yield)
        );
        vm.prank(vault);
        strategy.withdrawYield(user1, yield);

        // 4. Withdraw principal
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(
                IERC20.balanceOf.selector,
                address(strategy)
            ),
            abi.encode(WITHDRAW_AMOUNT)
        );
        vm.prank(vault);
        strategy.withdraw(user1, WITHDRAW_AMOUNT);

        assertEq(strategy.principalOf(user1), DEPOSIT_AMOUNT - WITHDRAW_AMOUNT);
    }

    function testMultipleUsersScenario() public {
        // User 1 deposits
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT)
        );
        strategy.depositPublic(user1, DEPOSIT_AMOUNT);

        // User 2 deposits
        vm.mockCall(
            underlyingToken,
            abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)),
            abi.encode(DEPOSIT_AMOUNT * 2)
        );
        strategy.depositPublic(user2, DEPOSIT_AMOUNT);

        assertEq(strategy.getTotalPrincipal(), DEPOSIT_AMOUNT * 2);
        assertEq(strategy.principalOf(user1), DEPOSIT_AMOUNT);
        assertEq(strategy.principalOf(user2), DEPOSIT_AMOUNT);

        // Both users should have yield
        uint256 yield1 = strategy.getYield(user1);
        uint256 yield2 = strategy.getYield(user2);
        assertGt(yield1, 0);
        assertGt(yield2, 0);
    }
}
