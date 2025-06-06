import { c as createComponent, b as createAstro, d as renderHead, e as renderSlot, r as renderTemplate } from './astro/server_SY2hFWwp.mjs';
import 'kleur/colors';
import 'html-escaper';
import 'clsx';

const $$Astro = createAstro();
const $$MainLayout = createComponent(($$result, $$props, $$slots) => {
  const Astro2 = $$result.createAstro($$Astro, $$props, $$slots);
  Astro2.self = $$MainLayout;
  const { children } = Astro2.slots;
  return renderTemplate`<html lang="en"> <head><meta charset="UTF-8"><title>AION – Immortal AI Agent</title><meta name="viewport" content="width=device-width, initial-scale=1.0">${renderHead()}</head> <body class="bg-zinc-950 text-white min-h-screen"> <main class="w-full min-h-screen flex flex-col items-center justify-center text-center px-4 py-12 animate-fade-in"> ${renderSlot($$result, $$slots["default"])} </main> </body></html>`;
}, "/Users/s/ming-template/base hack/AION_AI_Agent/mcp-frontend/src/layouts/MainLayout.astro", void 0);

export { $$MainLayout as $ };
