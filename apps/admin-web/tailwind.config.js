/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#E8F4F8',
          100: '#D1E9F1',
          500: '#4A90E2',
          600: '#357ABD',
          700: '#2C3E50',
        },
        coral: {
          400: '#FF6B6B',
          500: '#FF5252',
        },
        sand: '#FFF5E6',
        teal: '#50C9C3',
      },
    },
  },
  plugins: [],
}

