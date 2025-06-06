/* empty css                                   */
import { c as createComponent, a as renderComponent, r as renderTemplate, m as maybeRenderHead } from '../chunks/astro/server_SY2hFWwp.mjs';
import 'kleur/colors';
import 'html-escaper';
import { $ as $$MainLayout } from '../chunks/MainLayout_C0qPPGPH.mjs';
export { renderers } from '../renderers.mjs';

const $$Index = createComponent(($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "MainLayout", $$MainLayout, {}, { "default": ($$result2) => renderTemplate` ${maybeRenderHead()}<section class="flex flex-col items-center justify-center min-h-screen text-center bg-gradient-to-r from-black via-gray-900 to-black text-white px-6"> <h1 class="text-5xl font-bold mb-4">👁️ AION AI Agent</h1> <h2 class="text-xl mb-6">Immortal AI Agent on BNBChain</h2> <p class="max-w-xl text-lg mb-8">
Your decentralized AI assistant with sovereign memory, real-time learning, and DeFi automation — powered by Membase & BitAgent.
</p> <!-- ✅ Web3Provider + WalletInfo --> ${renderComponent($$result2, "Web3Provider", null, { "client:only": "react", "client:component-hydration": "only", "client:component-path": "/Users/s/ming-template/base hack/AION_AI_Agent/mcp-frontend/src/components/Web3Provider.jsx", "client:component-export": "default" }, { "default": ($$result3) => renderTemplate` ${renderComponent($$result3, "WalletInfo", null, { "client:only": "react", "client:component-hydration": "only", "client:component-path": "/Users/s/ming-template/base hack/AION_AI_Agent/mcp-frontend/src/components/WalletInfo.jsx", "client:component-export": "default" })} ` })} <!-- ✅ Dashboard link --> <a href="/dashboard" class="inline-block bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 px-6 rounded-lg transition duration-300 mt-8">
🚀 Launch Agent Dashboard
</a> </section> ` })}`;
}, "/Users/s/ming-template/base hack/AION_AI_Agent/mcp-frontend/src/pages/index.astro", void 0);

const $$file = "/Users/s/ming-template/base hack/AION_AI_Agent/mcp-frontend/src/pages/index.astro";
const $$url = "";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Index,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
