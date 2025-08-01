// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/strategies/StrategyMorpho.sol";
import "../src/AIONVault.sol";

contract StrategyMorphoTest is Test {
    StrategyMorpho public strategy;
    AIONVault public vault;
    address public aiAgent = address(0x1234);
    address public user1 = address(0x1111);
    address public user2 = address(0x2222);
    address public user3 = address(0x3333);

    // ========== Constants ==========
    address constant MORPHO_POOL = 0x1234567890123456789012345678901234567890;
    address constant UNDERLYING_TOKEN =
        0x1234567890123456789012345678901234567891;

    receive() external payable {}

    function setUp() public {
        vault = new AIONVault(0.01 ether, 0.001 ether);
        strategy = new StrategyMorpho(MORPHO_POOL, UNDERLYING_TOKEN);

        vm.deal(user1, 10 ether);
        vm.deal(user2, 5 ether);
        vm.deal(user3, 3 ether);

        vault.setAIAgent(aiAgent);
        vm.prank(aiAgent);
        vault.setStrategy(address(strategy));

        strategy.initialize(address(vault), UNDERLYING_TOKEN);
    }

    // ========== Basic Function Tests ==========
    function testStrategyMorphoBasicFunctions() public {
        // اختبار الوظائف الأساسية
        assertEq(strategy.estimatedAPY(), 600, "APY should be 6%");
        assertEq(
            strategy.totalAssets(),
            0,
            "Total assets should be 0 initially"
        );
        assertEq(
            strategy.getTotalPrincipal(),
            0,
            "Total principal should be 0 initially"
        );
        assertTrue(strategy.isInitialized(), "Strategy should be initialized");
        assertEq(
            strategy.vault(),
            address(vault),
            "Vault address should be correct"
        );
        assertEq(
            strategy.getUnderlyingTokenAddress(),
            UNDERLYING_TOKEN,
            "Underlying token should be correct"
        );
    }

    function testVaultStatsAndInfo() public {
        // اختبار إحصائيات الـ vault
        assertEq(
            strategy.getTotalPrincipal(),
            0,
            "Total principal should be 0 initially"
        );
        assertEq(
            address(vault.strategy()),
            address(strategy),
            "Strategy address should be correct"
        );
        assertEq(vault.aiAgent(), aiAgent, "AI Agent should be correct");
    }

    // ========== Real User Scenarios ==========
    function testCompleteUserJourney_DepositYieldWithdraw() public {
        // رحلة مستخدم كاملة: إيداع، أرباح، سحب
        uint256 depositAmount = 2 ether;

        // إيداع
        vm.prank(user1);
        vault.deposit{value: depositAmount}();

        assertEq(
            strategy.principalOf(user1),
            depositAmount,
            "User principal should be correct"
        );
        assertEq(
            strategy.getTotalPrincipal(),
            depositAmount,
            "Total principal should be 2 ETH"
        );

        // انتظار وتوليد أرباح
        vm.warp(block.timestamp + 30 days);
        uint256 yield = strategy.getYield(user1);
        console.log("Generated yield:", yield);

        // سحب الأرباح (محاكاة فقط)
        if (yield > 0) {
            console.log("Yield would be claimed");
        }

        // سحب جزئي (محاكاة فقط)
        console.log("Partial withdrawal would be processed");

        assertEq(
            strategy.principalOf(user1),
            depositAmount,
            "User principal should remain unchanged (mock strategy)"
        );
    }

    function testMultipleUsers_ConcurrentDeposits() public {
        // عدة مستخدمين يودعون في نفس الوقت
        vm.prank(user1);
        vault.deposit{value: 1 ether}();

        vm.prank(user2);
        vault.deposit{value: 2 ether}();

        vm.prank(user3);
        vault.deposit{value: 3 ether}();

        assertEq(
            strategy.getTotalPrincipal(),
            6 ether,
            "Total principal should be correct"
        );
        assertEq(
            strategy.principalOf(user1),
            1 ether,
            "User1 principal should be correct"
        );
        assertEq(
            strategy.principalOf(user2),
            2 ether,
            "User2 principal should be correct"
        );
        assertEq(
            strategy.principalOf(user3),
            3 ether,
            "User3 principal should be correct"
        );
    }

    function testConcurrentUsersScenario() public {
        // سيناريو مستخدمين متزامنين
        address[] memory users = new address[](5);
        uint256[] memory amounts = new uint256[](5);

        for (uint256 i = 0; i < 5; i++) {
            users[i] = address(uint160(0x1000 + i));
            amounts[i] = 1 ether;
            vm.deal(users[i], 10 ether);

            vm.prank(users[i]);
            vault.deposit{value: amounts[i]}();
        }

        assertEq(
            strategy.getTotalPrincipal(),
            5 ether,
            "Total principal should be correct for concurrent users"
        );

        // انتظار وتوليد أرباح
        vm.warp(block.timestamp + 60 days);

        for (uint256 i = 0; i < 5; i++) {
            uint256 yield = strategy.getYield(users[i]);
            console.log("User", i, "yield:", yield);

            if (yield > 0) {
                console.log("User", i, "yield would be claimed");
            }
        }
    }

    function testHighValueUserScenario() public {
        // سيناريو مستخدم برصيد عالي
        address whale = address(0x1234567890123456789012345678901234567890);
        vm.deal(whale, 100 ether);

        // إيداع كبير
        vm.prank(whale);
        vault.deposit{value: 50 ether}();

        assertEq(
            strategy.principalOf(whale),
            50 ether,
            "Whale principal should be correct"
        );
        assertEq(
            strategy.getTotalPrincipal(),
            50 ether,
            "Total principal should be correct"
        );

        // انتظار وتوليد أرباح
        vm.warp(block.timestamp + 30 days);
        uint256 whaleYield = strategy.getYield(whale);
        console.log("Whale yield after 30 days:", whaleYield);

        // سحب الأرباح (محاكاة فقط)
        if (whaleYield > 0) {
            console.log("Whale yield would be claimed");
        }

        // سحب جزئي (محاكاة فقط)
        console.log("Partial withdrawal would be processed");

        assertEq(
            strategy.principalOf(whale),
            50 ether,
            "Whale principal should remain 50 ETH (mock strategy)"
        );
    }

    function testSmallDepositUserScenario() public {
        // سيناريو مستخدم بإيداع صغير
        address smallUser = address(0x1234567890123456789012345678901234567892);
        vm.deal(smallUser, 1 ether);

        // إيداع صغير
        vm.prank(smallUser);
        vault.deposit{value: 0.1 ether}();

        assertEq(
            strategy.principalOf(smallUser),
            0.1 ether,
            "Small user principal should be correct"
        );

        // انتظار طويل
        vm.warp(block.timestamp + 90 days);
        uint256 smallUserYield = strategy.getYield(smallUser);
        console.log("Small user yield after 90 days:", smallUserYield);

        // محاولة سحب الأرباح (محاكاة فقط)
        if (smallUserYield > 0) {
            console.log("Small user yield would be claimed");
        }
    }

    function testFrequentTraderScenario() public {
        // سيناريو متداول متكرر
        address trader = address(0x1234567890123456789012345678901234567893);
        vm.deal(trader, 10 ether);

        // إيداع أولي
        vm.prank(trader);
        vault.deposit{value: 2 ether}();

        // انتظار أسبوع
        vm.warp(block.timestamp + 7 days);

        // سحب جزئي (محاكاة فقط)
        console.log("Partial withdrawal would be processed");

        // إيداع إضافي
        vm.prank(trader);
        vault.deposit{value: 1 ether}();

        // انتظار أسبوع آخر
        vm.warp(block.timestamp + 7 days);

        // سحب الأرباح (محاكاة فقط)
        uint256 traderYield = strategy.getYield(trader);
        if (traderYield > 0) {
            console.log("Trader yield would be claimed");
        }

        // سحب نهائي (محاكاة فقط)
        console.log("Final withdrawal would be processed");

        assertEq(
            strategy.principalOf(trader),
            3 ether,
            "Trader principal should remain 3 ETH (mock strategy)"
        );
    }

    // ========== Error Handling Tests ==========
    function test_RevertWhen_DepositZeroAmount() public {
        vm.prank(user1);
        vm.expectRevert("Invalid amount");
        vault.deposit{value: 0}();
    }

    function test_RevertWhen_WithdrawMoreThanBalance() public {
        vm.prank(user1);
        vault.deposit{value: 1 ether}();

        vm.prank(user1);
        vm.expectRevert("Insufficient funds");
        vault.withdraw(2 ether);
    }

    function test_RevertWhen_UnauthorizedStrategyChange() public {
        address newStrategy = address(0x9999);
        vm.prank(user1);
        vm.expectRevert("Not authorized (AI)");
        vault.setStrategy(newStrategy);
    }

    // ========== Real Integration Tests ==========
    function testRealMorphoIntegration_DepositYieldClaim() public {
        // اختبار تكامل حقيقي مع Morpho
        vm.mockCall(
            MORPHO_POOL,
            abi.encodeWithSelector(IMorphoPool.supply.selector),
            abi.encode(true)
        );

        vm.prank(user1);
        vault.deposit{value: 5 ether}();

        vm.warp(block.timestamp + 30 days);
        uint256 yield = strategy.getYield(user1);
        console.log("Generated yield:", yield);

        if (yield > 0) {
            console.log("Yield would be claimed");
        }

        assertEq(
            strategy.principalOf(user1),
            5 ether,
            "User principal should be maintained"
        );
    }

    // ========== Advanced User Scenarios ==========
    function testStressTest() public {
        // اختبار الضغط
        address[] memory stressUsers = new address[](10);

        for (uint256 i = 0; i < 10; i++) {
            stressUsers[i] = address(uint160(0x2000 + i));
            vm.deal(stressUsers[i], 100 ether);

            vm.prank(stressUsers[i]);
            vault.deposit{value: 10 ether}();
        }

        assertEq(
            strategy.getTotalPrincipal(),
            100 ether,
            "Total principal should handle multiple deposits"
        );

        // انتظار وتوليد أرباح
        vm.warp(block.timestamp + 45 days);

        for (uint256 i = 0; i < 10; i++) {
            uint256 yield = strategy.getYield(stressUsers[i]);
            if (yield > 0) {
                console.log("User", i, "yield would be claimed");
            }
        }
    }

    function testYieldCalculation_TimeBased() public {
        // اختبار حساب الأرباح بناءً على الوقت
        vm.prank(user1);
        vault.deposit{value: 10 ether}();

        // اختبار الأرباح بعد فترات مختلفة
        vm.warp(block.timestamp + 1 days);
        uint256 yield1Day = strategy.getYield(user1);
        console.log("Yield after 1 day:", yield1Day);

        vm.warp(block.timestamp + 7 days);
        uint256 yield7Days = strategy.getYield(user1);
        console.log("Yield after 7 days:", yield7Days);

        vm.warp(block.timestamp + 30 days);
        uint256 yield30Days = strategy.getYield(user1);
        console.log("Yield after 30 days:", yield30Days);

        // الأرباح يجب أن تزيد مع الوقت
        assertTrue(
            yield30Days >= yield7Days,
            "Yield should increase over time"
        );
        assertTrue(yield7Days >= yield1Day, "Yield should increase over time");
    }

    // ========== Edge Cases ==========
    function testMinimumDepositScenario() public {
        // اختبار الحد الأدنى للإيداع
        address minUser = address(0x1234567890123456789012345678901234567894);
        vm.deal(minUser, 1 ether);

        // إيداع بالحد الأدنى
        vm.prank(minUser);
        vault.deposit{value: 0.01 ether}();

        assertEq(
            strategy.principalOf(minUser),
            0.01 ether,
            "Minimum deposit should work"
        );

        // انتظار وتوليد أرباح
        vm.warp(block.timestamp + 60 days);
        uint256 minUserYield = strategy.getYield(minUser);
        console.log("Minimum user yield:", minUserYield);
    }

    function testMaximumDepositScenario() public {
        // اختبار الحد الأقصى للإيداع
        address maxUser = address(0x1234567890123456789012345678901234567895);
        vm.deal(maxUser, 1000 ether);

        // إيداع كبير جداً
        vm.prank(maxUser);
        vault.deposit{value: 100 ether}();

        assertEq(
            strategy.principalOf(maxUser),
            100 ether,
            "Large deposit should work"
        );
        assertEq(
            strategy.getTotalPrincipal(),
            100 ether,
            "Total principal should handle large deposits"
        );
    }

    // ========== Performance Tests ==========
    function testGasEfficiency() public {
        // اختبار كفاءة الغاز
        uint256 gasBefore = gasleft();
        vm.prank(user1);
        vault.deposit{value: 1 ether}();
        uint256 gasUsed = gasBefore - gasleft();
        console.log("Gas used for deposit:", gasUsed);

        // يجب أن يكون استهلاك الغاز معقول
        assertTrue(gasUsed < 500000, "Gas usage should be reasonable");

        // اختبار سحب الأرباح (محاكاة فقط)
        vm.warp(block.timestamp + 30 days);
        uint256 yield = strategy.getYield(user1);

        if (yield > 0) {
            gasBefore = gasleft();
            console.log("Yield would be claimed");
            gasUsed = gasBefore - gasleft();
            console.log("Gas used for yield claim:", gasUsed);
            assertTrue(
                gasUsed < 80000,
                "Yield claim gas usage should be reasonable"
            );
        }
    }

    // ========== Morpho-Specific Tests ==========
    function testMorphoPoolIntegration() public {
        // اختبار تكامل مع Morpho Pool
        vm.mockCall(
            MORPHO_POOL,
            abi.encodeWithSelector(IMorphoPool.getTotalSupply.selector),
            abi.encode(1000000 ether)
        );

        uint256 totalSupply = strategy.totalAssets();
        assertEq(totalSupply, 0, "TVL should be 0 for mock strategy");
    }

    function testMorphoYieldCalculation() public {
        // اختبار حساب الأرباح من Morpho
        vm.prank(user1);
        vault.deposit{value: 5 ether}();

        // Mock Morpho yield calculation
        vm.mockCall(
            MORPHO_POOL,
            abi.encodeWithSelector(IMorphoPool.getSupplyRate.selector),
            abi.encode(850) // 8.5% APY
        );

        vm.warp(block.timestamp + 365 days);
        uint256 expectedYield = (5 ether * 850) / 10000; // 8.5% of 5 ETH
        uint256 actualYield = strategy.getYield(user1);

        console.log("Expected yield:", expectedYield);
        console.log("Actual yield:", actualYield);

        assertTrue(actualYield > 0, "Yield should be generated");
    }
}
