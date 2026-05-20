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

  return { pageErrors, consoleErrors };
}

test('debug localhost proposed setup and appendix investigated', async ({ page }) => {
  const failedRequests = [];
  page.on('requestfailed', (request) => {
    failedRequests.push({
      url: request.url(),
      error: request.failure()?.errorText
    });
  });

  const routes = [
    'http://localhost:3000/proposed/setup/',
    'http://localhost:3000/appendix/investigated/'
  ];

  for (const route of routes) {
    const { pageErrors, consoleErrors } = await gotoWithoutRuntimeErrors(page, route);
    console.log(`ROUTE ${route}`);
    console.log(`H1 ${await page.locator('h1.title, h1').first().textContent()}`);
    console.log(`LOADERS ${await page.getByText('Loading...').count()}`);
    console.log(`SVGS ${await page.locator('svg').count()}`);
    console.log(`PAGE_ERRORS ${JSON.stringify(pageErrors)}`);
    console.log(`CONSOLE_ERRORS ${JSON.stringify(consoleErrors)}`);
    console.log(`FAILED_REQUESTS ${JSON.stringify(failedRequests)}`);
    console.log(`FIRST_CHART ${await page.locator('.chart-container').first().innerHTML().catch(() => '')}`);
    await page.screenshot({
      path: `debug-${route.includes('appendix') ? 'appendix-investigated' : 'proposed-setup'}.png`,
      fullPage: true
    });

    expect(pageErrors).toEqual([]);
    expect(consoleErrors).toEqual([]);
  }
});
