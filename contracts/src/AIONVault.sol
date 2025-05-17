// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title AIONVault - A simple DeFi vault to deposit and withdraw BNB
/// @author Samar
/// @notice This contract is used by the AION AI Agent for strategy execution

contract AIONVault {
    mapping(address => uint256) public balances;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    /// @notice Deposit BNB into the vault
    function deposit() external payable {
        require(msg.value > 0, "Must deposit > 0");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /// @notice Withdraw specified amount of BNB from vault
    /// @param amount Amount of BNB to withdraw
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient funds");

        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    /// @notice Get balance of a specific user
    /// @param user Address to query
    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }

    /// @notice Receive function to allow direct BNB transfers
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /// @notice Fallback function
    fallback() external payable {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }
}
