'use client';

import { useState, useRef } from 'react';
import WalletInfo from './WalletInfo.jsx';
import VaultBalance from './VaultBalance.jsx';
import VaultActions from './VaultActions.jsx';
import MemoryTimeline from './MemoryTimeline.jsx';
import AIRecommendation from './AIRecommendation.jsx';
import Footer from './Footer.jsx';
import EventLog from './EventLog.jsx';
import VaultChart from './VaultChart.jsx'; // ✅ NEW — Chart component

export default function Dashboard() {
  const [walletAddress, setWalletAddress] = useState(null);

  // Ref للـ MemoryTimeline Refresh Button
  const memoryRefreshRef = useRef(null);

  return (
    <div className="flex flex-col min-h-screen bg-black text-white">

      {/* Main Content */}
      <main className="flex-grow max-w-[1400px] mx-auto px-6 py-8 space-y-10">

        {/* Header */}
        <h1 className="text-5xl font-extrabold mb-6 text-indigo-400 text-center">👁️ AION AI Agent Dashboard</h1>

        {/* Row 1: Wallet Info + Vault Balance */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <section className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in">
            <h2 className="text-xl font-bold mb-3">Wallet Info</h2>
            <WalletInfo setWalletAddress={setWalletAddress} />
          </section>

          <section className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in">
            <h2 className="text-xl font-bold mb-3">Vault Balance</h2>
            <VaultBalance />
          </section>
        </div>

        {/* Row 2: Vault Actions + AI Recommendation */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <section className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in">
            <h2 className="text-xl font-bold mb-3">Vault Actions</h2>
            <VaultActions
              walletAddress={walletAddress}
              memoryRefreshRef={memoryRefreshRef}
            />
          </section>

          <section className="bg-gradient-to-r from-indigo-600 to-blue-600 p-6 rounded-lg shadow-lg text-white animate-fade-in">
            <h2 className="text-xl font-bold mb-3">AI Recommendation</h2>
            <AIRecommendation walletAddress={walletAddress} />
          </section>
        </div>

        {/* Row 3: Vault Balance Chart */}
        <VaultChart walletAddress={walletAddress} />

        {/* Row 4: Memory Timeline */}
        <section className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in">
          <h2 className="text-xl font-bold mb-3">📜 Vault Memory Timeline</h2>
          <MemoryTimeline walletAddress={walletAddress} ref={memoryRefreshRef} />
        </section>

        {/* Row 5: Event Log */}
        <section className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in">
          <h2 className="text-xl font-bold mb-3">📋 Event Log</h2>
          <EventLog walletAddress={walletAddress} />
        </section>

      </main>

      {/* Footer */}
      <Footer />
    </div>
  );
}
