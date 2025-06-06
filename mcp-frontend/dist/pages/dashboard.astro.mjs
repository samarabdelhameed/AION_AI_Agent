/* empty css                                   */
import { c as createComponent, a as renderComponent, r as renderTemplate, m as maybeRenderHead } from '../chunks/astro/server_SY2hFWwp.mjs';
import 'kleur/colors';
import 'html-escaper';
import { $ as $$MainLayout } from '../chunks/MainLayout_C0qPPGPH.mjs';
export { renderers } from '../renderers.mjs';

const $$Dashboard = createComponent(($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "MainLayout", $$MainLayout, {}, { "default": ($$result2) => renderTemplate` ${maybeRenderHead()}<section class="flex flex-col items-center justify-center min-h-screen text-center text-white"> <h1 class="text-4xl font-bold mb-6">🛠️ Agent Dashboard</h1> <p class="text-lg mb-4">Welcome to your AION AI Agent Dashboard!</p> <p class="text-zinc-400">More features coming soon 🚀</p> </section> ` })}`;
}, "/Users/s/ming-template/base hack/AION_AI_Agent/mcp-frontend/src/pages/dashboard.astro", void 0);

const $$file = "/Users/s/ming-template/base hack/AION_AI_Agent/mcp-frontend/src/pages/dashboard.astro";
const $$url = "/dashboard";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Dashboard,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
