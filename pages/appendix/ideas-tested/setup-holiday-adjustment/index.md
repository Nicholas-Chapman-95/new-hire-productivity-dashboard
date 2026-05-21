---
title: Setup Holiday Adjustment
sidebar_position: 5
queries:
  - appendix_setup_holiday_business_day_summary: dev/appendix_setup_holiday_business_day_summary.sql
  - appendix_setup_holiday_office_coverage: dev/appendix_setup_holiday_office_coverage.sql
  - context_pr_office_seasonality: dev/context_pr_office_seasonality.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/appendix/ideas-tested">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Ideas Tested and Set Aside</span>
  </a>
</div>

<p class="eyebrow page-eyebrow">Appendix</p>
<p class="appendix-backlink"><a href="/appendix/ideas-tested">Back to ideas tested and set aside</a></p>

Working-day and public-holiday adjustment was investigated for setup, but it did not change the new-hire setup read enough to replace calendar days on the core page.

- We did build a real business-day prototype rather than just discussing the idea.
- The prototype reduced the measured setup time, but it did not change the ranking or management read enough to replace calendar days.
- The more useful output was a clearer seasonality caution around year-end throughput.

<div class="metric-strip metric-strip--centered">
  <BigValue data={appendix_setup_holiday_business_day_summary} value=median_calendar_days title="Median Calendar Days" fmt=num1 />
  <BigValue data={appendix_setup_holiday_business_day_summary} value=median_business_days title="Median Business Days" fmt=num1 />
  <BigValue data={appendix_setup_holiday_business_day_summary} value=median_gap_days title="Median Day Gap" fmt=num1 />
  <BigValue data={appendix_setup_holiday_business_day_summary} value=configured_hires title="Configured-Holidays Hires" fmt=num0 />
</div>

<div class="feature-panel">
  <h2>What We Actually Built</h2>
  <p>This prototype was implemented in the dbt layer, not handled as a hand-wavy adjustment.</p>

  <ul>
    <li><code>02_transformations/seeds/office_holiday_calendars.csv</code> maps each office to a holiday calendar code, with <code>WEEKDAY_ONLY</code> as the fallback.</li>
    <li><code>02_transformations/seeds/public_holidays.csv</code> seeds the curated public-holiday dates used by the prototype calendars.</li>
    <li><code>int_business_calendar.sql</code> expands those calendars into one date-by-calendar table with <code>is_weekday</code>, <code>is_public_holiday</code>, and <code>is_business_day</code>.</li>
    <li><code>fct_employee_onboarding_summary.sql</code> then derives <code>business_days_to_first_pr</code> by summing only the dates marked as business days between onboarding start and the first merged PR.</li>
  </ul>

  <Details title="Office-to-calendar coverage in the onboarding sample">
    <DataTable data={appendix_setup_holiday_office_coverage}>
      <Column id=office title="Office" />
      <Column id=holiday_calendar_code title="Calendar Code" />
      <Column id=calendar_status title="Calendar Status" />
      <Column id=hires title="Hires" fmt=num0 />
      <Column id=median_calendar_days title="Median Calendar Days" fmt=num1 />
      <Column id=median_business_days title="Median Business Days" fmt=num1 />
      <Column id=median_gap_days title="Median Gap" fmt=num1 />
      <Column id=average_gap_days title="Average Gap" fmt=num1 />
    </DataTable>
  </Details>
</div>

<div class="feature-panel">
  <h2>Why It Still Did Not Become The Default KPI</h2>
  <ul>
    <li>The prototype changed the unit, but not the practical story strongly enough to justify replacing the simpler calendar-day setup read.</li>
    <li>The current sample is fully configured only for the offices that appear in the observed Software Engineering onboarding slice here, not as a full global leave model.</li>
    <li>The method still leaves out personal leave, reviewer absence, and team-specific local working patterns.</li>
  </ul>
</div>

<div class="feature-panel">
  <h2>What It Did Reveal Clearly</h2>
  <p>The stronger surviving insight was office-level seasonality in PR throughput, especially around the year-end slowdown.</p>

<LineChart
    data={context_pr_office_seasonality}
    x=month_date
    y=prs
    series=office
    title="Merged PR count by month in London and Tallinn"
    yFmt=num0
    yMin=0
    markers=true
    lineWidth=2
    seriesColors={{
      'London': '#355c7d',
      'Tallinn': '#2a9d8f'
    }}
    xAxisTitle=true
    yAxisTitle=true
/>

  <p class="mini-caption">Keep the setup KPI on calendar days. Use this seasonality check as a caution on year-end interpretation instead.</p>
</div>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/appendix/ideas-tested">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Ideas Tested and Set Aside →</span>
  </a>
</div>
