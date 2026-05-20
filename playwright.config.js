import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  timeout: 30_000,
  retries: 0,
  use: {
    baseURL: 'http://127.0.0.1:8001',
    headless: true,
    viewport: { width: 1440, height: 1200 }
  },
  webServer: {
    command: 'npm run build && python3 -m http.server 8001 --directory build --bind 127.0.0.1',
    port: 8001,
    reuseExistingServer: true,
    timeout: 120_000
  }
});
