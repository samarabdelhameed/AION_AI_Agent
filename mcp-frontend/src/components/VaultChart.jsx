'use client';

import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { useEffect, useState } from 'react';

// ✅ Helper: Detect Trend (last vs previous)
function detectTrend(data) {
  if (data.length < 2) return 'Stable ➖';
  const latest = data[0].balance;
  const previous = data[1].balance;
  if (latest > previous) return 'Upward 📈';
  if (latest < previous) return 'Downward 📉';
  return 'Stable ➖';
}

// ✅ Custom Tooltip Component
function CustomTooltip({ active, payload, label, data }) {
  if (active && payload && payload.length) {
    const trend = detectTrend(data);
    return (
      <div className="bg-black bg-opacity-80 p-3 rounded-lg text-white text-sm border border-gray-500">
        <p className="mb-1">📅 Date: <strong>{label}</strong></p>
        <p>💰 Vault Balance: <strong>{parseFloat(payload[0].value).toFixed(6)} BNB</strong></p>
        <p>📊 Trend: <strong>{trend}</strong></p>
      </div>
    );
  }

  return null;
}

export default function VaultChart({ walletAddress }) {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);

  // ✅ Save computed trend to display it in Title
  const [trend, setTrend] = useState('Stable ➖');

  useEffect(() => {
    const fetchHistory = async () => {
      if (!walletAddress) {
        setData([]);
        setTrend('Stable ➖');
        return;
      }

      setLoading(true);

      try {
        const response = await fetch(`http://localhost:3001/history/${walletAddress}`);
        const rawData = await response.json();

        // Prepare data for chart: timestamp vs vault balance
        const chartData = rawData.map(entry => ({
          timestamp: entry.date ? entry.date : 'N/A',
          balance: parseFloat(entry.vault) || 0
        })).reverse();

        setData(chartData);

        // Compute trend for Title
        const computedTrend = detectTrend(chartData);
        setTrend(computedTrend);
      } catch (err) {
        console.error('VaultChart Error:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchHistory();
  }, [walletAddress]);

  return (
    <div className="bg-zinc-800 p-6 rounded-lg shadow-md animate-fade-in mt-6">
      <h2 className="text-xl font-bold mb-3 text-white">
        📈 Vault Balance Chart <span className="text-sm text-gray-400">(Trend: {trend})</span>
      </h2>

      {loading ? (
        <div className="text-center text-gray-400 py-12 animate-pulse">
          Loading Vault Balance Chart...
        </div>
      ) : (
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={data} margin={{ top: 20, right: 30, left: 20, bottom: 40 }}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis
              dataKey="timestamp"
              stroke="#ccc"
              label={{
                value: 'Date',
                position: 'insideBottom',
                offset: -5,
                fill: '#ccc'
              }}
            />
            <YAxis
              stroke="#ccc"
              label={{
                value: 'Vault Balance (BNB)',
                angle: -90,
                position: 'insideLeft',
                offset: 10,
                fill: '#ccc'
              }}
            />
            <Tooltip content={<CustomTooltip data={data} />} />
            <Line
              type="monotone"
              dataKey="balance"
              stroke="#4ade80"
              strokeWidth={3}
              dot={{ r: 5 }}
              activeDot={{ r: 8 }}
              isAnimationActive={true}
              animationDuration={800}
            />
          </LineChart>
        </ResponsiveContainer>
      )}
    </div>
  );
}
