// src/components/WalletInfo.jsx
'use client';

import { useState, useEffect } from 'react';
import { ethers } from 'ethers';

export default function WalletInfo() {
  const [account, setAccount] = useState(null);
  const [network, setNetwork] = useState(null);

  // ✅ Connect Wallet Function
  const connectWallet = async () => {
    try {
      if (window.ethereum) {
        const provider = new ethers.BrowserProvider(window.ethereum);
        const signer = await provider.getSigner();
        const address = await signer.getAddress();
        setAccount(address);

        const net = await provider.getNetwork();
        setNetwork(net);
      } else {
        alert('MetaMask not detected');
      }
    } catch (err) {
      console.error('Error connecting wallet:', err);
    }
  };

  // ✅ Disconnect Wallet Function
  const disconnectWallet = () => {
    setAccount(null);
    setNetwork(null);
  };

  // ✅ On mount, check if already connected
  useEffect(() => {
    const handleAccountsChanged = (accounts) => {
      if (accounts.length > 0) {
        setAccount(accounts[0]);
      } else {
        disconnectWallet();
      }
    };

    const handleChainChanged = async () => {
      await connectWallet();
    };

    if (window.ethereum) {
      window.ethereum.on('accountsChanged', handleAccountsChanged);
      window.ethereum.on('chainChanged', handleChainChanged);
    }

    return () => {
      if (window.ethereum) {
        window.ethereum.removeListener('accountsChanged', handleAccountsChanged);
        window.ethereum.removeListener('chainChanged', handleChainChanged);
      }
    };
  }, []);

  // ✅ Check if on BNB Testnet (chainId 97)
  const isTestnet = network?.chainId === 97;

  return (
    <div className="bg-zinc-800 p-6 rounded-lg shadow space-y-4 text-center">
      <h3 className="text-2xl font-bold mb-2">Wallet Info</h3>

      {/* ✅ Testnet Banner */}
      {isTestnet && (
        <div className="bg-yellow-400 text-black px-4 py-2 rounded-lg font-semibold mb-2">
          ⚠️ You are on BNB Testnet
        </div>
      )}

      {/* ✅ Connect / Disconnect Buttons */}
      {!account ? (
        <button
          onClick={connectWallet}
          className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-6 rounded-lg transition duration-300"
        >
          🔌 Connect Wallet
        </button>
      ) : (
        <>
          <p className="text-green-400 break-all">
            ✅ Connected: {account}
          </p>
          <p className="text-zinc-300 text-sm">
            Network: {network?.name || 'Unknown'} (Chain ID: {network?.chainId})
          </p>
          <button
            onClick={disconnectWallet}
            className="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-6 rounded-lg transition duration-300 mt-2"
          >
            🔌 Disconnect Wallet
          </button>
        </>
      )}
    </div>
  );
}
