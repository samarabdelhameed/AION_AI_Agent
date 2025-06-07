'use client';

import { useEffect, useState } from 'react';

export default function AIRecommendation({ walletAddress }) {
  const [recommendation, setRecommendation] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const fetchRecommendation = async () => {
    if (!walletAddress) {
      setRecommendation('Please connect your wallet to see AI recommendations.');
      return;
    }

    setLoading(true);
    setError('');
    setRecommendation('');

    try {
      const response = await fetch(`http://localhost:3001/analyze/${walletAddress}`);
      if (!response.ok) {
        throw new Error('Failed to fetch AI recommendation');
      }

      const data = await response.json();
      setRecommendation(`🤖 AI Suggests: ${data.suggested_action}`);
    } catch (err) {
      console.error('AI Recommendation Error:', err);
      setError('AI recommendation is currently unavailable.');
    } finally {
      setLoading(false);
    }
  };

  // 🟢 Run when walletAddress changes
  useEffect(() => {
    fetchRecommendation();
  }, [walletAddress]);

  return (
    <section className="bg-gradient-to-r from-blue-600 to-indigo-700 p-4 rounded-lg text-white shadow-md animate-fade-in">
      <div className="flex justify-between items-center mb-2">
        <h2 className="text-xl font-bold">🤖 AI Recommendation</h2>
        {walletAddress && (
          <button
            onClick={fetchRecommendation}
            className="bg-blue-300 hover:bg-blue-400 text-black font-bold py-1 px-3 rounded text-sm transition duration-300"
          >
            🔄 Refresh
          </button>
        )}
      </div>

      {loading ? (
        <p className="text-base leading-relaxed animate-pulse">Fetching AI recommendation...</p>
      ) : error ? (
        <p className="text-red-400">{error}</p>
      ) : (
        <p className="text-base leading-relaxed">{recommendation}</p>
      )}
    </section>
  );
}
