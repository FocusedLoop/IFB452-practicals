import { defineConfig } from 'vite';
import solidPlugin from 'vite-plugin-solid';
import devtools from 'solid-devtools/vite';

// Setup Vite config for development and building the app
export default defineConfig({
  plugins: [devtools(), solidPlugin()],
  server: {
    port: 3002,
  },
  build: {
    target: 'esnext',
  },
});
