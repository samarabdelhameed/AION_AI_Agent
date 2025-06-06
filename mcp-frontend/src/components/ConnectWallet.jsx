'use client';

import React, { useState } from 'react';
import { ethers } from 'ethers';

export default function ConnectWallet() {
  const [account, setAccount] = useState(null);

  const connectWallet = async () => {
    try {
      if (window.ethereum) {
        const provider = new ethers.BrowserProvider(window.ethereum);
        const accounts = await provider.send('eth_requestAccounts', []);
        setAccount(accounts[0]);
      } else {
        alert('Please install MetaMask!');
      }
    } catch (error) {
      console.error('Error connecting wallet:', error);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center mt-6">
      {account ? (
        <p className="text-green-400 font-bold mb-2">Connected: {account}</p>
      ) : (
        <button
          onClick={connectWallet}
          className="bg-green-500 hover:bg-green-600 text-white font-bold py-3 px-7 rounded-lg shadow-lg transition duration-300 ease-in-out transform hover:-translate-y-1 hover:scale-105 animate-fade-in"
        >
          Connect Wallet
        </button>
      )}
    </div>
  );
}
