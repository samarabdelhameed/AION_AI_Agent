// src/components/VaultActions.jsx
'use client';

import { useState } from 'react';
import { ethers } from 'ethers';
import { vaultABI } from '../abi/vaultABI';

export default function VaultActions() {
  const [amount, setAmount] = useState('');
  const [loading, setLoading] = useState(false);
  const CONTRACT_ADDRESS = import.meta.env.PUBLIC_CONTRACT_ADDRESS;

  const handleDeposit = async () => {
    try {
      if (!window.ethereum) {
        alert('MetaMask not detected');
        return;
      }
      setLoading(true);
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const vaultContract = new ethers.Contract(CONTRACT_ADDRESS, vaultABI, signer);

      const tx = await vaultContract.deposit({ value: ethers.parseEther(amount) });
      await tx.wait();
      alert(`✅ Deposit of ${amount} BNB successful!`);
      setAmount('');
    } catch (err) {
      console.error('Deposit Error:', err);
      alert('❌ Deposit failed.');
    } finally {
      setLoading(false);
    }
  };

  const handleWithdraw = async () => {
    try {
      if (!window.ethereum) {
        alert('MetaMask not detected');
        return;
      }
      setLoading(true);
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const vaultContract = new ethers.Contract(CONTRACT_ADDRESS, vaultABI, signer);

      const tx = await vaultContract.withdraw(ethers.parseEther(amount));
      await tx.wait();
      alert(`✅ Withdrawal of ${amount} BNB successful!`);
      setAmount('');
    } catch (err) {
      console.error('Withdraw Error:', err);
      alert('❌ Withdraw failed.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center py-6 px-6 bg-zinc-800 text-white rounded-lg shadow-md animate-fade-in space-y-4">
      <h2 className="text-xl font-bold mb-2">Vault Actions</h2>

      <input
        type="number"
        placeholder="Amount in BNB"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        className="px-4 py-2 rounded bg-zinc-900 border border-zinc-600 text-white w-full"
      />

      <div className="flex gap-4 mt-2">
        <button
          onClick={handleDeposit}
          disabled={loading || !amount}
          className="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded transition"
        >
          {loading ? 'Processing...' : '📥 Deposit'}
        </button>

        <button
          onClick={handleWithdraw}
          disabled={loading || !amount}
          className="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded transition"
        >
          {loading ? 'Processing...' : '📤 Withdraw'}
        </button>
      </div>
    </div>
  );
}
