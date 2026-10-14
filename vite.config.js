import { defineConfig } from 'vite';

export default defineConfig({
  base: '/wedding/',
  server: {
    port: 5188,
    strictPort: true,
    host: true,
    open: false,
  },
  preview: {
    port: 5188,
    strictPort: true,
    host: true,
  },
});
