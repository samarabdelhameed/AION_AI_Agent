// src/components/WalletInfo.jsx

import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useAccount, useDisconnect } from 'wagmi';

export default function WalletInfo() {
  const { address, isConnected } = useAccount();
  const { disconnect } = useDisconnect();

  return (
    <div className="flex flex-col items-center justify-center py-10 gap-4 animate-fade-in">
      <h2 className="text-3xl font-bold text-white">Welcome to AION AI Agent 🚀</h2>
      <p className="text-gray-300 mb-4">Connect your wallet to get started.</p>

      {/* RainbowKit Connect Button */}
      <ConnectButton />

      {/* If connected, show wallet address and disconnect button */}
      {isConnected && (
        <div className="mt-6 flex flex-col items-center gap-2">
          <p className="text-green-400 break-all text-center">
            ✅ Connected: {address}
          </p>
          <button
            onClick={() => disconnect()}
            className="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-6 rounded-lg transition duration-300"
          >
            🔌 Disconnect Wallet
          </button>
        </div>
      )}
    </div>
  );
}
