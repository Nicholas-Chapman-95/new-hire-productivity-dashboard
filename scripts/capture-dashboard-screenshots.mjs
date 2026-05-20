import { chromium } from '@playwright/test';
import fs from 'node:fs/promises';
import path from 'node:path';

const baseUrl = process.env.BASE_URL || 'http://127.0.0.1:8010';
const outputDir = path.resolve('qa-screenshots');

const pages = [
  ['home', '/'],
  ['onboarding', '/onboarding/'],
  ['integration', '/integration/'],
  ['ramp', '/ramp/'],
  ['friction', '/friction/'],
  ['squads', '/squads/'],
  ['methodology', '/methodology/']
];

await fs.mkdir(outputDir, { recursive: true });

const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1440, height: 2200 } });

for (const [name, route] of pages) {
  await page.goto(`${baseUrl}${route}`, { waitUntil: 'networkidle' });
  await page.screenshot({
    path: path.join(outputDir, `${name}.png`),
    fullPage: true
  });
}

await browser.close();
