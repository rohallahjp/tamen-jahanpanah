const { defineConfig, loadEnv } = require('vite');
const react = require('@vitejs/plugin-react');

// https://vitejs.dev/config/
module.exports = defineConfig(({ mode }) => {
  // Load env file based on `mode` in the current working directory.
  // Set the third parameter to '' to load all env regardless of the `VITE_` prefix.
  const env = loadEnv(mode, process.cwd(), '');

  return {
    plugins: [react()],
    server: {
      host: '0.0.0.0',
    },
    define: {
      'process.env.API_KEY': JSON.stringify(env.API_KEY),
    },
    build: {
      rollupOptions: {
        external: ['@google/genai'],
      },
    },
  };
});
