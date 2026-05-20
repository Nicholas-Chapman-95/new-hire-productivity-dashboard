---
title: Setup Holiday Adjustment
sidebar_position: 7
queries:
  - context_pr_office_seasonality: dev/context_pr_office_seasonality.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/appendix/cross-office-squads">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Cross-Office Squads</span>
  </a>
</div>

Working-day and public-holiday adjustment was investigated for setup, but it did not change the new-hire setup read enough to replace calendar days on the core page.

- The useful signal was seasonality in overall PR throughput, not a materially better new-hire headline metric.
- `December` dips and `January` rebounds are visible in both `London` and `Tallinn`.
- The prototype still would not account for personal leave or team-specific reviewer absence.

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

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/appendix/integration">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Integration →</span>
  </a>
</div>
