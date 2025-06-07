// src/components/Dashboard.jsx
'use client';

import { useState } from 'react';
import WalletInfo from './WalletInfo.jsx';
import VaultBalance from './VaultBalance.jsx';
import VaultActions from './VaultActions.jsx';
import MemoryTimeline from './MemoryTimeline.jsx';
import AIRecommendation from './AIRecommendation.jsx';
import Footer from './Footer.jsx';

export default function Dashboard() {
  // 🟢 Wallet Address state → عشان نبعته للـ AI + MemoryTimeline
  const [walletAddress, setWalletAddress] = useState(null);

  return (
    <div className="flex flex-col min-h-screen bg-black text-white">

      {/* Main Content */}
      <main className="flex-grow max-w-6xl mx-auto px-4 py-8 grid grid-cols-1 md:grid-cols-2 gap-8">

        {/* Column 1 */}
        <div className="space-y-6">

          {/* Header */}
          <h1 className="text-4xl font-extrabold mb-6 text-indigo-400">👁️ AION AI Agent Dashboard</h1>

          {/* Wallet Info */}
          <section className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in">
            <h2 className="text-xl font-bold mb-3">Wallet Info</h2>
            <WalletInfo setWalletAddress={setWalletAddress} />
          </section>

          {/* Vault Balance */}
          <section className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in">
            <h2 className="text-xl font-bold mb-3">Vault Balance</h2>
            <VaultBalance />
          </section>

          {/* Vault Actions */}
          <section className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in">
            <h2 className="text-xl font-bold mb-3">Vault Actions</h2>
            <VaultActions />
          </section>
        </div>

        {/* Column 2 */}
        <div className="space-y-6">

          {/* AI Agent & Memory Timeline */}
          <h2 className="text-2xl font-bold mb-2 text-indigo-400">AI Agent & Memory Timeline</h2>

          {/* AI Recommendation */}
          <section className="bg-gradient-to-r from-indigo-600 to-blue-600 p-6 rounded-lg shadow-lg text-white animate-fade-in">
            <AIRecommendation walletAddress={walletAddress} />
          </section>

          {/* Memory Timeline */}
          <section className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in">
            <MemoryTimeline walletAddress={walletAddress} />
          </section>
        </div>
      </main>

      {/* Footer */}
      <Footer />
    </div>
  );
}
