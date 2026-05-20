---
title: Setup
sidebar_label: Setup / Initial Unblocking
sidebar_position: 1
queries:
  - proposed_setup_summary_cards: dev/proposed_setup_summary_cards.sql
  - proposed_setup_30d_completion_monthly: dev/proposed_setup_30d_completion_monthly.sql
  - proposed_setup_summary_all: dev/proposed_setup_summary_all.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/proposed">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Proposed</span>
  </a>
</div>

Use `% with first PR by day 30` as the main setup KPI because it is a clearer operating read than raw `time to first PR`.

- `Time to first PR` tells us about speed, but `% with first PR by day 30` more clearly shows how many hires have cleared a reasonable setup window.
- `% with first PR by day 30` gives a cleaner manager follow-up signal: did the hire reach an initial contribution point inside the first month or not.
- Timing statistics still matter as supporting context for spread and tail risk after we read the completion rate.

- `30-Day Observed` is the subset with a full 30 calendar days of post-hire observation.
- `PR By Day 30` is the number of observed hires who actually cleared that setup window.

<div style="display:none;">
<Dropdown name=day_basis defaultValue="calendar">
  <DropdownOption value="calendar" valueLabel="Calendar Days" />
</Dropdown>
<Dropdown name=role_productivity_category defaultValue="Software Engineering">
  <DropdownOption value="Software Engineering" valueLabel="Software Engineering" />
</Dropdown>

<Dropdown name=employee_type defaultValue="Permanent">
  <DropdownOption value="Permanent" valueLabel="Permanent" />
</Dropdown>

<Dropdown name=office defaultValue="%">
  <DropdownOption value="%" valueLabel="All Offices" />
</Dropdown>

<Dropdown name=management_level defaultValue="%">
  <DropdownOption value="%" valueLabel="All Levels" />
</Dropdown>

<Dropdown name=squad defaultValue="%">
  <DropdownOption value="%" valueLabel="All Squads" />
</Dropdown>

<Dropdown name=sub_team defaultValue="%">
  <DropdownOption value="%" valueLabel="All Sub-Teams" />
</Dropdown>
</div>

## Core readout

<Grid cols=3>
  <BigValue data={proposed_setup_summary_cards} value=observed_30d_hires title="30-Day Observed" fmt=num0 />
  <BigValue data={proposed_setup_summary_cards} value=completed_30d_hires title="PR By Day 30" fmt=num0 />
  <BigValue data={proposed_setup_summary_cards} value=pct_within_30_days title="% With First PR By Day 30" fmt=num1 />
</Grid>

<Details title="Show timing context">
  <Grid cols=3>
    <BigValue data={proposed_setup_summary_cards} value=median_days_to_first_pr title="Median Days" fmt=num1 />
    <BigValue data={proposed_setup_summary_cards} value=average_days_to_first_pr title="Mean Days" fmt=num1 />
    <BigValue data={proposed_setup_summary_cards} value=p75_days_to_first_pr title="P75 Days" fmt=num1 />
  </Grid>

  <p class="mini-caption">Use timing cards as backup context for spread and tail risk after reading the 30-day completion rate.</p>
</Details>

## Main evidence

<LineChart
    data={proposed_setup_30d_completion_monthly}
    x=cohort_date
    y=pct_by_threshold
    y2=observed_completion_hires
    y2SeriesType=bar
    title="% with first PR by day 30 and observed cohort size"
    yFmt=num1
    y2Fmt=num0
    yMin=0
    yMax=100
    markers=true
    lineWidth=2
    seriesColors={['#355c7d']}
    xAxisTitle=true
    yAxisTitle=true
/>

## Timing Context

`% with first PR by day 30` remains the setup KPI. `Time to first PR` is the supporting timing measure: it shows how long hires typically take to reach that first contribution point, which helps us see whether a change in the KPI is broad-based or concentrated in slower cases.

<LineChart
    data={proposed_setup_summary_all}
    x=cohort_date
    y=days
    series=series
    title="Time to first PR by cohort month"
    yFmt=num1
    yMin=0
    markers=true
    lineWidth=2
    seriesOrder={['Median', 'Average', 'P25', 'P75']}
    seriesColors={{
      'Median': '#1f5f8b',
      'Average': '#2c7a7b',
      'P25': '#c46f4f',
      'P75': '#d39d68'
    }}
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">If the completion rate worsens while the median stays steady, the problem is more likely concentrated in slower cases than in the typical setup path. If the median, upper tail, and completion rate all move together, that is more likely to be a real setup slowdown.</p>
<p class="mini-caption">This timing view does not replace the KPI choice. We use it to interpret the `day 30` completion read, not to switch back to raw <code>time to first PR</code>. The `day 30` KPI stays preferable because it is bounded and keeps unresolved hires visible after the first month.</p>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/proposed/setup/decomposition">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Setup Drivers →</span>
  </a>
</div>
