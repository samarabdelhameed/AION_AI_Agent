// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("Test Token", "TEST") {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }
}

contract MockBeefyVault is ERC20 {
    IERC20 public underlyingToken;

    constructor(address _underlyingToken) ERC20("Mock Beefy Vault", "mBEEFY") {
        underlyingToken = IERC20(_underlyingToken);
    }

    function deposit(uint256 amount) external {
        underlyingToken.transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
    }

    function withdraw(uint256 shares) external {
        _burn(msg.sender, shares);
        underlyingToken.transfer(msg.sender, shares);
    }
}

contract BeefyTest is Test {
    MockToken public token;
    MockBeefyVault public beefyVault;

    address public owner;
    address public user1;
    address public user2;

    // Real Beefy data for testing
    uint256 public constant BEEFY_APY = 1200; // 12% APY (real Beefy data)
    uint256 public constant BEEFY_RISK_LEVEL = 3; // Medium risk
    uint256 public constant MIN_DEPOSIT = 1e18; // 1 token
    uint256 public constant PERFORMANCE_FEE = 200; // 2%
    uint256 public constant MANAGEMENT_FEE = 50; // 0.5%

    // Test amounts
    uint256 public constant SMALL_DEPOSIT = 10e18; // 10 tokens
    uint256 public constant MEDIUM_DEPOSIT = 100e18; // 100 tokens
    uint256 public constant LARGE_DEPOSIT = 1000e18; // 1000 tokens

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        token = new MockToken();
        beefyVault = new MockBeefyVault(address(token));

        token.transfer(user1, 10000e18);
        token.transfer(user2, 10000e18);
    }

    function testTokenCreation() public {
        assertEq(token.name(), "Test Token");
        assertEq(token.symbol(), "TEST");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), 1000000 * 10 ** 18);
    }

    function testBeefyVaultCreation() public {
        assertEq(beefyVault.name(), "Mock Beefy Vault");
        assertEq(beefyVault.symbol(), "mBEEFY");
        assertEq(beefyVault.decimals(), 18);
    }

    function testUserTokenBalances() public {
        assertEq(token.balanceOf(user1), 10000e18);
        assertEq(token.balanceOf(user2), 10000e18);
    }

    function testBeefyVaultDeposit() public {
        vm.startPrank(user1);

        uint256 depositAmount = SMALL_DEPOSIT;
        token.approve(address(beefyVault), depositAmount);
        beefyVault.deposit(depositAmount);

        assertEq(beefyVault.balanceOf(user1), depositAmount);
        assertEq(token.balanceOf(user1), 10000e18 - depositAmount);

        vm.stopPrank();
    }

    function testBeefyVaultWithdraw() public {
        vm.startPrank(user1);

        // First deposit
        uint256 depositAmount = SMALL_DEPOSIT;
        token.approve(address(beefyVault), depositAmount);
        beefyVault.deposit(depositAmount);

        // Then withdraw
        beefyVault.withdraw(depositAmount);

        assertEq(beefyVault.balanceOf(user1), 0);
        assertEq(token.balanceOf(user1), 10000e18);

        vm.stopPrank();
    }

    function testMultipleUsersDeposit() public {
        // User 1 deposits
        vm.startPrank(user1);
        token.approve(address(beefyVault), SMALL_DEPOSIT);
        beefyVault.deposit(SMALL_DEPOSIT);
        vm.stopPrank();

        // User 2 deposits
        vm.startPrank(user2);
        token.approve(address(beefyVault), MEDIUM_DEPOSIT);
        beefyVault.deposit(MEDIUM_DEPOSIT);
        vm.stopPrank();

        // Verify deposits
        assertEq(beefyVault.balanceOf(user1), SMALL_DEPOSIT);
        assertEq(beefyVault.balanceOf(user2), MEDIUM_DEPOSIT);
        assertEq(token.balanceOf(user1), 10000e18 - SMALL_DEPOSIT);
        assertEq(token.balanceOf(user2), 10000e18 - MEDIUM_DEPOSIT);
    }

    function testLargeDeposit() public {
        vm.startPrank(user1);

        uint256 depositAmount = LARGE_DEPOSIT;
        token.approve(address(beefyVault), depositAmount);
        beefyVault.deposit(depositAmount);

        assertEq(beefyVault.balanceOf(user1), depositAmount);
        assertEq(token.balanceOf(user1), 10000e18 - depositAmount);

        vm.stopPrank();
    }

    function testComplexScenario() public {
        // Phase 1: Initial deposits
        vm.startPrank(user1);
        token.approve(address(beefyVault), SMALL_DEPOSIT);
        beefyVault.deposit(SMALL_DEPOSIT);
        vm.stopPrank();

        vm.startPrank(user2);
        token.approve(address(beefyVault), MEDIUM_DEPOSIT);
        beefyVault.deposit(MEDIUM_DEPOSIT);
        vm.stopPrank();

        // Phase 2: User withdrawals
        vm.startPrank(user1);
        uint256 shares1 = beefyVault.balanceOf(user1);
        beefyVault.withdraw(shares1 / 2);
        vm.stopPrank();

        vm.startPrank(user2);
        uint256 shares2 = beefyVault.balanceOf(user2);
        beefyVault.withdraw(shares2);
        vm.stopPrank();

        // Verify final state
        assertGt(beefyVault.balanceOf(user1), 0);
        assertEq(beefyVault.balanceOf(user2), 0);
        assertGt(token.balanceOf(user1), 10000e18 - SMALL_DEPOSIT);
        assertEq(token.balanceOf(user2), 10000e18);
    }

    function testGasOptimization() public {
        vm.startPrank(user1);

        uint256 gasBefore = gasleft();

        token.approve(address(beefyVault), SMALL_DEPOSIT);
        beefyVault.deposit(SMALL_DEPOSIT);

        uint256 gasUsed = gasBefore - gasleft();

        // Gas should be reasonable (less than 200k for deposit)
        assertLt(gasUsed, 200000);

        vm.stopPrank();
    }
} 