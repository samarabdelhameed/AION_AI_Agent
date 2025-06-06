/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{astro,html,js,jsx,ts,tsx}", // خليه كده عشان يغطي كل الملفات
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
