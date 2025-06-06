'use client';

import WalletInfo from './WalletInfo.jsx';
import VaultBalance from './VaultBalance.jsx';

export default function Dashboard() {
  return (
    <div className="max-w-6xl mx-auto px-4 py-8 text-white grid grid-cols-1 md:grid-cols-2 gap-8">
      {/* Column 1 */}
      <div className="space-y-6">
        <h1 className="text-4xl font-extrabold mb-4">👁️ AION AI Agent Dashboard</h1>

        {/* Wallet Info */}
        <div className="bg-zinc-800 p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-bold mb-3">Wallet Info</h2>
          <WalletInfo />
        </div>

        {/* Vault Balance */}
        <div className="bg-zinc-800 p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-bold mb-3">Vault Balance</h2>
          <VaultBalance />
        </div>
      </div>

      {/* Column 2 */}
      <div className="space-y-6">
        <h2 className="text-2xl font-bold mb-2">AI Agent & Memory Timeline</h2>
        <p className="text-zinc-400">Coming soon: AI Analyze / Memory Timeline</p>
      </div>
    </div>
  );
}
