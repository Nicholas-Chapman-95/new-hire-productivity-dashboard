import { expect, test } from '@playwright/test';

async function gotoWithoutRuntimeErrors(page, route) {
  const pageErrors = [];
  const consoleErrors = [];
  const resolvedRoute = route === '/' ? route : `${route.replace(/\/+$/, '')}/`;

  page.on('pageerror', (error) => {
    pageErrors.push(error.message);
  });

  page.on('console', (message) => {
    if (message.type() === 'error') {
      consoleErrors.push(message.text());
    }
  });

  await page.goto(resolvedRoute);
  await page.waitForLoadState('networkidle');

  expect(pageErrors).toEqual([]);
  expect(consoleErrors).toEqual([]);
  await expect(page.getByText('Reference Point cannot be used outside of a chart')).toHaveCount(0);
}

async function expectNoPersistentLoading(page) {
  await expect
    .poll(async () => page.getByText('Loading...', { exact: true }).count(), {
      timeout: 10_000,
      message: 'Expected all dashboard components to resolve without persistent Loading... states'
    })
    .toBe(0);
}

async function expectDashboardFiltersToFit(page) {
  const filters = page.locator('.dashboard-filters');
  await expect(filters).toBeVisible();

  const result = await filters.evaluate((node) => {
    const containerRect = node.getBoundingClientRect();
    const fields = Array.from(node.querySelectorAll('.dashboard-filter-field'));

    const issues = fields.flatMap((field, index) => {
      const rect = field.getBoundingClientRect();
      const localIssues = [];

      if (rect.right - containerRect.right > 1) {
        localIssues.push(`field ${index} overflows right edge`);
      }
      if (rect.bottom - containerRect.bottom > 1) {
        localIssues.push(`field ${index} overflows bottom edge`);
      }

      if (field.scrollWidth > field.clientWidth + 1) {
        localIssues.push(`field ${index} has horizontal scroll overflow`);
      }

      const nextField = fields[index + 1];
      if (nextField) {
        const nextRect = nextField.getBoundingClientRect();
        const sameRow = Math.abs(nextRect.top - rect.top) < 8;
        if (sameRow && rect.right - nextRect.left > 1) {
          localIssues.push(`field ${index} overlaps field ${index + 1}`);
        }
      }

      return localIssues;
    });

    return {
      scrollOverflowX: node.scrollWidth > node.clientWidth + 1,
      scrollOverflowY: node.scrollHeight > node.clientHeight + 1,
      issues
    };
  });

  expect(result.scrollOverflowX).toBeFalsy();
  expect(result.scrollOverflowY).toBeFalsy();
  expect(result.issues).toEqual([]);
}

test('summary page renders key dashboard sections', async ({ page }) => {
  await gotoWithoutRuntimeErrors(page, '/');

  await expect(page.locator('h1.title')).toHaveText('New-Hire Productivity');
  await expect(page.locator('.dashboard-hero').first()).toBeVisible();
  await expectDashboardFiltersToFit(page);
  await expect(page.getByText('Current decision state')).toBeVisible();
  await expect(page.getByText('Ramp toward expected output')).toBeVisible();
  await expect(page.getByText('Choose the layer you want to inspect')).toBeVisible();

  await expect(page.locator('.dashboard-hero').first()).toHaveScreenshot('summary-hero.png');
  await expect(page.locator('.dashboard-filters')).toHaveScreenshot('summary-filters.png');
  await expect(page.locator('.metric-strip')).toHaveScreenshot('summary-kpis.png');
  await expect(page.locator('.feature-panel')).toHaveScreenshot('summary-feature-panel.png');
});

test('focused onboarding page renders its primary chart section', async ({ page }) => {
  await gotoWithoutRuntimeErrors(page, '/onboarding');

  await expect(page.locator('h1.title')).toHaveText('Onboarding');
  await expect(page.getByText('Use this page for setup, access, and first-task quality')).toBeVisible();
  await expect(page.getByText('Early unblock rates by cohort')).toBeVisible();
  await expectDashboardFiltersToFit(page);

  await expect(page.locator('.dashboard-hero').first()).toHaveScreenshot('onboarding-hero.png');
  await expect(page.locator('.story-card').first()).toHaveScreenshot('onboarding-primary-card.png');
});

test('squad explorer renders drill-down layout', async ({ page }) => {
  await gotoWithoutRuntimeErrors(page, '/squads');

  await expect(page.locator('h1.title')).toHaveText('Squad Explorer');
  await expectDashboardFiltersToFit(page);
  await expect(page.locator('.metric-strip')).toBeVisible();
  await expect(page.locator('.dashboard-hero').first()).toHaveScreenshot('squads-hero.png');
  await expect(page.locator('.metric-strip')).toHaveScreenshot('squads-kpis.png');
});

test('summary page mobile layout remains stable', async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 1200 });
  await gotoWithoutRuntimeErrors(page, '/');

  await expect(page.locator('h1.title')).toHaveText('New-Hire Productivity');
  await expectDashboardFiltersToFit(page);
  await expect(page.locator('.dashboard-hero').first()).toHaveScreenshot('summary-mobile-hero.png');
  await expect(page.locator('.dashboard-filters')).toHaveScreenshot('summary-mobile-filters.png');
});

test('status quo and metric validity routes render without runtime errors', async ({ page }) => {
  const routes = [
    ['/status-quo', 'Status Quo'],
    ['/status-quo/metric-validity', 'Metric Validity']
  ];

  for (const [route, heading] of routes) {
    await gotoWithoutRuntimeErrors(page, route);
    await expect(page.locator('h1.title')).toHaveText(heading);
  }
});

test('status quo KPI cards and charts resolve without persistent loading states', async ({ page }) => {
  await gotoWithoutRuntimeErrors(page, '/status-quo');

  await expect(page.locator('h1.title')).toHaveText('Status Quo');
  await expectNoPersistentLoading(page);
  await expect(page.getByText('Eligible Hires')).toBeVisible();
  await expect(page.getByText('Median Days')).toBeVisible();
  await expect(page.locator('.chart-container').first()).toBeVisible();
});
