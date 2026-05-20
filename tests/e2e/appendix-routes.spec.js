import { expect, test } from '@playwright/test';

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
  await page.waitForLoadState('networkidle');

  expect(pageErrors).toEqual([]);
  expect(consoleErrors).toEqual([]);
  await expect(page.getByText('Reference Point cannot be used outside of a chart')).toHaveCount(0);
}

test('appendix investigated and integration routes render without runtime errors', async ({ page }) => {
  const routes = [
    ['/appendix/investigated', 'Investigated, Not Advanced'],
    ['/appendix/integration', 'Integration']
  ];

  for (const [route, heading] of routes) {
    await gotoWithoutRuntimeErrors(page, route);
    await expect(page.locator('h1.title')).toHaveText(heading);
  }
});
