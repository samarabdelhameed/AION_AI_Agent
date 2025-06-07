// src/components/VaultBalance.jsx
'use client';

import { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import { vaultABI } from '../abi/vaultABI';

export default function VaultBalance() {
  const [account, setAccount] = useState(null);
  const [balance, setBalance] = useState(null);
  const [loading, setLoading] = useState(false);

  const CONTRACT_ADDRESS = import.meta.env.PUBLIC_CONTRACT_ADDRESS;

  const fetchBalance = async (userAddress) => {
    try {
      setLoading(true);
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();

      const vaultContract = new ethers.Contract(CONTRACT_ADDRESS, vaultABI, signer);

      const userBalance = await vaultContract.balanceOf(userAddress);
      setBalance(ethers.formatEther(userBalance));
    } catch (err) {
      console.error('Error fetching balance:', err);
      setBalance(null);
    } finally {
      setLoading(false);
    }
  };

  const checkWallet = async () => {
    if (window.ethereum) {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const address = await signer.getAddress();
      setAccount(address);
      await fetchBalance(address);
    }
  };

  useEffect(() => {
    checkWallet();

    // Listen for account change
    if (window.ethereum) {
      window.ethereum.on('accountsChanged', (accounts) => {
        if (accounts.length > 0) {
          setAccount(accounts[0]);
          fetchBalance(accounts[0]);
        } else {
          setAccount(null);
          setBalance(null);
        }
      });

      window.ethereum.on('chainChanged', () => {
        checkWallet();
      });
    }
  }, []);

  return (
    <div className="flex flex-col items-center justify-center py-6 px-6 bg-zinc-800 text-white rounded-lg shadow-md animate-fade-in">
      <div className="flex justify-between items-center w-full mb-4">
        <h2 className="text-xl font-bold">Vault Balance</h2>
        {account && (
          <button
            id="refresh-vault-balance-button" // ✅ Added ID here for programmatic refresh
            onClick={() => fetchBalance(account)}
            className="bg-blue-500 hover:bg-blue-600 text-white text-sm font-bold py-1 px-3 rounded"
          >
            🔄 Refresh
          </button>
        )}
      </div>

      {loading ? (
        <p className="text-gray-400">Loading...</p>
      ) : (
        <>
          {account ? (
            <p className="text-green-400 text-lg">
              {balance ? `${balance} BNB` : '0 BNB'}
            </p>
          ) : (
            <p className="text-gray-400">Please connect your wallet first.</p>
          )}
        </>
      )}
    </div>
  );
}
