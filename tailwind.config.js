

/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        // Replaced 'Vazirmatn' with a system-safe font 'Tahoma' for better offline/intranet compatibility.
        sans: ['Tahoma', 'sans-serif'],
      },
      transitionProperty: {
        'margin': 'margin',
      },
      keyframes: {
        'fade-in-right': {
          '0%': { opacity: '0', transform: 'translateX(-20px)' },
          '100%': { opacity: '1', transform: 'translateX(0)' },
        },
      },
      animation: {
        'fade-in-right': 'fade-in-right 0.3s ease-out forwards',
      },
    },
  },
  plugins: [],
};
