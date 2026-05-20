---
title: PRs
sidebar_position: 2
queries:
  - context_pr_summary_cards: dev/context_pr_summary_cards.sql
  - context_pr_history_monthly: dev/context_pr_history_monthly.sql
  - context_pr_office_seasonality: dev/context_pr_office_seasonality.sql
  - context_pr_rolling_ramp_summary: dev/context_pr_rolling_ramp_summary.sql
  - context_pr_rolling_ramp_windows: dev/context_pr_rolling_ramp_windows.sql
  - context_pr_rolling_ramp_by_squad: dev/context_pr_rolling_ramp_by_squad.sql
  - context_pr_baseline_population_comparison: dev/context_pr_baseline_population_comparison.sql
  - context_pr_baseline_by_squad: dev/context_pr_baseline_by_squad.sql
  - context_pr_baseline_repo_group: dev/context_pr_baseline_repo_group.sql
  - context_pr_baseline_first_pr_vs_baseline: dev/context_pr_baseline_first_pr_vs_baseline.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/context/employees">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Employees</span>
  </a>
</div>

This page gives PR-cycle baselines before we interpret `Time to First PR` or ask whether a new hire's first PR looks unusually fast.

> Scope: engineering PRs only. Negative cycle-time rows are excluded here because `created_at > merged_at` in the synthetic PR source for a substantial share of rows, which makes the cycle-time metric invalid.

<Grid cols=4>
<BigValue data={context_pr_summary_cards} value=total_prs title="Total PRs" fmt=num0 />
<BigValue data={context_pr_summary_cards} value=engineering_prs title="Engineering PRs" fmt=num0 />
<BigValue data={context_pr_summary_cards} value=invalid_cycle_prs title="Invalid Timestamp PRs" fmt=num0 />
<BigValue data={context_pr_summary_cards} value=new_hire_first_prs title="Valid New-Hire First PRs" fmt=num0 />
</Grid>

## PR history over time

<LineChart
    data={context_pr_history_monthly}
    x=month
    y=prs
    title="Merged PR count by month"
    yFmt=num0
    yMin=0
    markers=true
    lineWidth=2
    color="#355c7d"
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">Merged PR history in this dataset starts on <code>2025-03-01</code>.</p>

## Office Seasonality

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

<p class="mini-caption">Both offices dip in `December` and rebound in `January`. That is a cleaner reason to treat year-end setup cohorts cautiously than switching the headline setup metric to holiday-adjusted working days.</p>

## Data Quality Note

The PR timestamp fields in this synthetic dataset do not consistently reflect real merge ordering.

- `7,562` PRs have `merged_at < created_at`
- `7,491` PRs have `closed_at < created_at`
- `17,991` PRs have `closed_at < merged_at`

That means `closed_at` is not a safe replacement for `merged_at`, and raw cycle time should not be read as reliable unless those impossible timestamp rows are excluded first.

## Rolling 30-Day Ramp

<Grid cols=3>
<BigValue data={context_pr_rolling_ramp_summary} value=median_first_30_days_prs title="Median PRs In First 30 Days" fmt=num1 />
<BigValue data={context_pr_rolling_ramp_summary} value=median_second_30_days_prs title="Median PRs In Days 30-59" fmt=num1 />
<BigValue data={context_pr_rolling_ramp_summary} value=median_third_30_days_prs title="Median PRs In Days 60-89" fmt=num1 />
</Grid>

<BarChart
    data={context_pr_rolling_ramp_windows}
    x=ramp_window
    y=median_prs
    title="Median PRs by rolling 30-day window"
    fillColor="#2a9d8f"
    sort=false
    yFmt=num1
    yMin=0
    xAxisTitle=true
    yAxisTitle=true
/>

<DataTable data={context_pr_rolling_ramp_windows}>
    <Column id=ramp_window title="Rolling Window" />
    <Column id=eligible_hires title="Eligible Hires" fmt=num0 />
    <Column id=median_prs title="Median PRs" fmt=num1 />
    <Column id=avg_prs title="Average PRs" fmt=num1 />
</DataTable>

<p class="mini-caption">This is the cleaner onboarding ramp view. Unlike calendar `ramp_month`, these windows are equal-length and avoid penalizing hires who joined late in a month.</p>

<DataTable data={context_pr_rolling_ramp_by_squad}>
    <Column id=squad title="Squad" />
    <Column id=hires_30d title="Hires With 30 Days" fmt=num0 />
    <Column id=median_first_30_days_prs title="Median PRs In First 30 Days" fmt=num1 />
    <Column id=hires_60d title="Hires With 60 Days" fmt=num0 />
    <Column id=median_second_30_days_prs title="Median PRs In Days 30-59" fmt=num1 />
    <Column id=hires_90d title="Hires With 90 Days" fmt=num0 />
    <Column id=median_third_30_days_prs title="Median PRs In Days 60-89" fmt=num1 />
</DataTable>

## Population Comparison

<DataTable data={context_pr_baseline_population_comparison}>
    <Column id=population title="Population" />
    <Column id=prs title="PRs" fmt=num0 />
    <Column id=median_cycle_time_days title="Median Cycle Time (Days)" fmt=num2 />
    <Column id=avg_cycle_time_days title="Average Cycle Time (Days)" fmt=num2 />
    <Column id=pct_within_1_day title="% Within 1 Day" fmt=pct1 />
    <Column id=pct_within_3_days title="% Within 3 Days" fmt=pct1 />
    <Column id=pct_within_7_days title="% Within 7 Days" fmt=pct1 />
</DataTable>

<BarChart
    data={context_pr_baseline_population_comparison}
    x=population
    y=median_cycle_time_days
    title="Median cycle time by PR population"
    fillColor="#355c7d"
    sort=false
    yFmt=num2
    yMin=0
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">The main question here is whether new-hire first PRs are unusually fast relative to normal engineering PRs. So far, they look broadly similar rather than radically different.</p>

## New-Hire First PR Versus Baseline

<DataTable data={context_pr_baseline_first_pr_vs_baseline}>
    <Column id=comparison title="Comparison" />
    <Column id=prs title="PRs" fmt=num0 />
    <Column id=first_pr_median_cycle_time_days title="First PR Median" fmt=num2 />
    <Column id=baseline_median_cycle_time_days title="Baseline Median" fmt=num2 />
    <Column id=median_delta_cycle_time_days title="Median Delta" fmt=num2 />
    <Column id=pct_faster_than_baseline title="% Faster Than Baseline" fmt=pct1 />
    <Column id=pct_slower_than_baseline title="% Slower Than Baseline" fmt=pct1 />
</DataTable>

<p class="mini-caption">This compares each new hire's first PR to the usual PR-cycle time in that same repo, and then to the usual PR-cycle time in that same squad and repo-area. If first PRs were mostly tiny setup changes, we would expect them to be much faster than those local baselines.</p>

## By Squad

<LineChart
    data={context_pr_baseline_by_squad}
    x=squad
    y=median_cycle_time_days
    series=population
    title="Median cycle time by squad"
    yFmt=num2
    yMin=0
    markers=true
    lineWidth=2
    xLabelWrap=true
    seriesColors={{
      'New-hire first PR': '#2a9d8f',
      'Tenured engineering PRs': '#355c7d'
    }}
    xAxisTitle=true
    yAxisTitle=true
/>

<DataTable data={context_pr_baseline_by_squad}>
    <Column id=population title="Population" />
    <Column id=squad title="Squad" />
    <Column id=prs title="PRs" fmt=num0 />
    <Column id=median_cycle_time_days title="Median Cycle Time (Days)" fmt=num2 />
    <Column id=avg_cycle_time_days title="Average Cycle Time (Days)" fmt=num2 />
    <Column id=pct_within_1_day title="% Within 1 Day" fmt=pct1 />
</DataTable>

## By Repo Group

<BarChart
    data={context_pr_baseline_repo_group}
    x=repo_group
    y=median_cycle_time_days
    title="Median cycle time by repo group"
    fillColor="#6c5b7b"
    sort=false
    yFmt=num2
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>

<DataTable data={context_pr_baseline_repo_group}>
    <Column id=repo_group title="Repo Group" />
    <Column id=prs title="PRs" fmt=num0 />
    <Column id=median_cycle_time_days title="Median Cycle Time (Days)" fmt=num2 />
    <Column id=avg_cycle_time_days title="Average Cycle Time (Days)" fmt=num2 />
    <Column id=pct_within_1_day title="% Within 1 Day" fmt=pct1 />
</DataTable>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/context/repos">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Repos →</span>
  </a>
</div>
