// components/CustomTooltip.jsx

export default function CustomTooltip({ active, payload, label }) {
    if (active && payload && payload.length) {
      return (
        <div className="bg-black bg-opacity-80 p-3 rounded-lg text-white text-sm border border-gray-500">
          <p className="mb-1">📅 Date: <strong>{label}</strong></p>
          <p>💰 Vault Balance: <strong>{parseFloat(payload[0].value).toFixed(6)} BNB</strong></p>
        </div>
      );
    }
  
    return null;
  }
  