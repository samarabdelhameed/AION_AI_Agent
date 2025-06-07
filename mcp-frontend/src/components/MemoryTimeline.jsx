'use client';

import { useEffect, useState } from 'react';

export default function MemoryTimeline({ walletAddress }) {
  const [entries, setEntries] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const fetchMemory = async () => {
    if (!walletAddress) {
      setEntries([]);
      setError('Please connect your wallet to view memory timeline.');
      return;
    }

    setLoading(true);
    setError('');

    try {
      const response = await fetch(`http://localhost:3001/memory/${walletAddress}`);
      if (!response.ok) {
        throw new Error('Failed to fetch memory timeline');
      }

      const data = await response.json();

      // لو data array أو object → بنرجع array
      const formatted = Array.isArray(data)
        ? data
        : data.length
        ? data
        : [];

      setEntries(formatted.reverse()); // نعرض الأحدث فوق
    } catch (err) {
      console.error('MemoryTimeline Error:', err);
      setError('Failed to load memory timeline.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchMemory();
  }, [walletAddress]);

  return (
    <div className="flex flex-col bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in text-white">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-bold">📜 Vault Memory Timeline</h2>
        <button
          onClick={fetchMemory}
          className="bg-blue-500 hover:bg-blue-600 text-white text-sm font-bold py-1 px-3 rounded"
        >
          🔄 Refresh
        </button>
      </div>

      {loading && (
        <p className="text-gray-400 animate-pulse">Loading memory timeline...</p>
      )}

      {error && (
        <p className="text-red-400 mb-4">{error}</p>
      )}

      {entries.length === 0 && !loading && !error ? (
        <p className="text-gray-400">No recent events found.</p>
      ) : (
        <table className="w-full text-sm text-left">
          <thead>
            <tr className="border-b border-zinc-700">
              <th className="pb-2">Action</th>
              <th className="pb-2">Amount (BNB)</th>
              <th className="pb-2">Strategy</th>
              <th className="pb-2">Timestamp</th>
            </tr>
          </thead>
          <tbody>
            {entries.map((entry, idx) => (
              <tr key={idx} className="border-t border-zinc-700">
                <td className="py-2">{entry.metadata?.last_action || entry.last_action || 'Unknown'}</td>
                <td className="py-2 text-green-400">{entry.metadata?.amount || entry.amount || 'N/A'}</td>
                <td className="py-2">{entry.metadata?.strategy || entry.strategy || 'N/A'}</td>
                <td className="py-2">{entry.created_at ? entry.created_at.split('T')[0] : 'N/A'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}