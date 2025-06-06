// astro.config.mjs
import { defineConfig } from "astro/config";
import tailwind from "@astrojs/tailwind";
import react from "@astrojs/react"; // ✅ Enable React integration for Client Components (RainbowKit + Wagmi)

// Astro Config
export default defineConfig({
  integrations: [
    tailwind(),
    react(), // ✅ Add React integration
  ],
});
