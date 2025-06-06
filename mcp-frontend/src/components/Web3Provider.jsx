// src/components/Web3Provider.jsx

import { WagmiConfig, createClient, configureChains } from 'wagmi';
import { publicProvider } from 'wagmi/providers/public';
import { mainnet, bscTestnet } from 'wagmi/chains';
import { RainbowKitProvider, getDefaultWallets } from '@rainbow-me/rainbowkit';
import '@rainbow-me/rainbowkit/styles.css';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

// Configure chains ✅
const { chains, provider, webSocketProvider } = configureChains(
  [bscTestnet, mainnet],
  [publicProvider()]
);

// Get default wallets ✅
const { connectors } = getDefaultWallets({
  appName: 'AION AI Agent',
  projectId: '22f175ea79dc018f0ec6bc13c4f4aee7',
});

// Create wagmi client ✅
const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
  webSocketProvider,
});

// Create React Query Client ✅
const queryClient = new QueryClient();

export default function Web3Provider({ children }) {
  return (
    <QueryClientProvider client={queryClient}>
      <WagmiConfig client={wagmiClient}>
        <RainbowKitProvider chains={chains}>
          {children}
        </RainbowKitProvider>
      </WagmiConfig>
    </QueryClientProvider>
  );
}
