// src/components/VaultInfo.jsx
'use client';

import { useEffect, useState } from 'react';
import { ethers } from 'ethers';

// Replace with your Vault Contract Address + ABI
const VAULT_CONTRACT_ADDRESS = '0xYourVaultContractAddressHere';
const VAULT_ABI = [
  // Example ABI for balanceOf function
  'function balanceOf(address account) view returns (uint256)'
];

export default function VaultInfo() {
  const [vaultBalance, setVaultBalance] = useState(null);

  useEffect(() => {
    async function fetchVaultBalance() {
      try {
        const provider = new ethers.BrowserProvider(window.ethereum);
        const signer = await provider.getSigner();
        const userAddress = await signer.getAddress();

        const vaultContract = new ethers.Contract(VAULT_CONTRACT_ADDRESS, VAULT_ABI, provider);
        const balance = await vaultContract.balanceOf(userAddress);

        // Convert from wei to Ether
        setVaultBalance(ethers.formatEther(balance));
      } catch (error) {
        console.error('Error fetching vault balance:', error);
      }
    }

    fetchVaultBalance();
  }, []);

  return (
    <div className="bg-zinc-800 p-4 rounded-lg shadow">
      <h3 className="text-xl font-bold mb-2">Vault Balance</h3>
      {vaultBalance !== null ? (
        <p className="text-green-400 text-lg">{vaultBalance} BNB</p>
      ) : (
        <p className="text-zinc-400">Loading...</p>
      )}
    </div>
  );
}
