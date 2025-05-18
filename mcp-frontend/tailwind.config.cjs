/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{astro,html,js,jsx,ts,tsx,vue,svelte}',
    './layouts/**/*.{astro,html}',
    './pages/**/*.{astro,html}',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#3b82f6',
        dark: '#111827',
      },
    },
  },
  plugins: [],
};
