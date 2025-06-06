'use client';

import { WagmiProvider, createConfig, http } from 'wagmi';
import { mainnet, bscTestnet } from 'wagmi/chains';
import { InjectedConnector } from '@wagmi/connectors/injected';
import { RainbowKitProvider, ConnectButton } from '@rainbow-me/rainbowkit';
import '@rainbow-me/rainbowkit/styles.css';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

// Create React Query Client
const queryClient = new QueryClient();

// Create Wagmi Config
const wagmiConfig = createConfig({
  autoConnect: true,
  chains: [bscTestnet, mainnet],
  connectors: [new InjectedConnector()],
  transports: {
    [bscTestnet.id]: http(),
    [mainnet.id]: http(),
  },
});

export default function Web3Provider() {
  return (
    <QueryClientProvider client={queryClient}>
      <WagmiProvider config={wagmiConfig}>
        <RainbowKitProvider chains={[bscTestnet, mainnet]}>
          <div className="mb-6">
            <ConnectButton />
          </div>
        </RainbowKitProvider>
      </WagmiProvider>
    </QueryClientProvider>
  );
}
