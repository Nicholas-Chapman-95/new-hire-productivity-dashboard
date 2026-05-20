import { test, expect } from '@playwright/test';

const pages = [
  ['home', '/'],
  ['onboarding', '/onboarding'],
  ['integration', '/integration'],
  ['ramp', '/ramp'],
  ['friction', '/friction'],
  ['squads', '/squads'],
  ['methodology', '/methodology'],
  ['metric-validity', '/status-quo/metric-validity']
];

async function gotoWithoutRuntimeErrors(page, route) {
  const pageErrors = [];
  const consoleErrors = [];

  page.on('pageerror', (error) => {
    pageErrors.push(error.message);
  });

  page.on('console', (message) => {
    if (message.type() === 'error') {
      consoleErrors.push(message.text());
    }
  });

  await page.goto(route);
  await expect(page.locator('article')).toBeVisible();
  await page.waitForLoadState('networkidle');

  expect(pageErrors).toEqual([]);
  expect(consoleErrors).toEqual([]);
  await expect(page.getByText('Reference Point cannot be used outside of a chart')).toHaveCount(0);
}

test.describe('manual dashboard QA capture', () => {
  for (const [name, route] of pages) {
    test(`${name} page capture`, async ({ page }, testInfo) => {
      await gotoWithoutRuntimeErrors(page, route);
      await page.waitForTimeout(1500);
      if (
        name !== 'home' &&
        name !== 'methodology' &&
        name !== 'squads' &&
        name !== 'metric-validity'
      ) {
        await page.locator('.story-card').scrollIntoViewIfNeeded();
        await page.waitForTimeout(1000);
      }
      await page.screenshot({
        path: testInfo.outputPath(`${name}.png`),
        fullPage: true
      });
    });
  }
});
