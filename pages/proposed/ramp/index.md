---
title: Ramp
sidebar_position: 3
queries:
  - proposed_ramp_summary_cards: dev/proposed_ramp_summary_cards.sql
  - proposed_ramp_raw_curve_long: dev/proposed_ramp_raw_curve_long.sql
  - proposed_ramp_crossing_curve: dev/proposed_ramp_crossing_curve.sql
  - proposed_ramp_curve: dev/proposed_ramp_curve.sql
  - proposed_ramp_share_curve: dev/proposed_ramp_share_curve.sql
  - proposed_ramp_segment_benchmarks: dev/proposed_ramp_segment_benchmarks.sql
  - proposed_ramp_cohort_cumulative_avg: dev/proposed_ramp_cohort_cumulative_avg.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/proposed/setup/decomposition">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Setup Drivers</span>
  </a>
</div>

Start with raw ramp pace across exact `30-day` windows, then use the local benchmark to judge whether that pace is enough.

<p class="mini-caption"><strong>Local benchmark:</strong> the typical tenured-engineer PR pace over a comparable `30-day` window, using `office + squad` where possible, otherwise `office + level`, otherwise `office`, otherwise the overall engineering benchmark.</p>
<p class="mini-caption"><strong>Scope:</strong> valid onboarding cases only, `Software Engineering` hires, `Permanent` employees.</p>

- Raw PR pace is the first read because it shows the actual ramp shape in `0-29`, `30-59`, and `60-89`.
- The local-benchmark read is second because raw output alone does not tell us whether that pace is enough for the hire's local environment.
- Use `% at local benchmark by day 90` as the main checkpoint once we move from raw pace to relative sufficiency.

<div class="metric-strip metric-strip--centered">
<Grid cols=5>
<BigValue data={proposed_ramp_summary_cards} value=median_prs_0_29 title="Median PRs, 0-29" fmt=num1 />
<BigValue data={proposed_ramp_summary_cards} value=median_prs_30_59 title="Median PRs, 30-59" fmt=num1 />
<BigValue data={proposed_ramp_summary_cards} value=median_prs_60_89 title="Median PRs, 60-89" fmt=num1 />
<BigValue data={proposed_ramp_summary_cards} value=median_prs_90_119 title="Median PRs, 90-119" fmt=num1 />
<BigValue data={proposed_ramp_summary_cards} value=median_prs_120_149 title="Median PRs, 120-149" fmt=num1 />
</Grid>
</div>

<p class="mini-caption">These are the main raw ramp checkpoints. They show whether output is rising across the first three exact `30-day` windows after hire.</p>

## Main evidence

- A rising median means the typical hire is making more PRs over time.
- `P25` and `P75` show whether the ramp is tight or highly variable.
- This is absolute output, not yet a read on whether the pace is sufficient for the local peer context.

<LineChart
    data={proposed_ramp_raw_curve_long}
    x=day_window_label
    y=pr_count
    series=series
    title="New-Hire PRs per 30-Day Window"
    yFmt=num1
    yMin=0
    sort=false
    showAllXAxisLabels=true
    seriesOrder={['P25', 'Median', 'P75']}
    xAxisTitle=true
    yAxisTitle=true
/>

## Local Benchmark

Use this after the raw pace read. This section asks whether the observed ramp is enough to match normal local peer pace.

- `% at local benchmark by day 90` is the main end-of-probation checkpoint.
- `Median days to local benchmark` is the supporting pace summary.
- `% at local benchmark by day 60` is an earlier watchpoint, not a second headline KPI.

<Grid cols=2>
<BigValue data={proposed_ramp_summary_cards} value=benchmark_by_day_90 title="% At Local Benchmark By Day 90" fmt=pct1 />
<BigValue data={proposed_ramp_summary_cards} value=median_days_to_benchmark title="Median Days to Local Benchmark" fmt=num0 />
</Grid>

<LineChart
    data={proposed_ramp_crossing_curve}
    x=day_window_label
    y=pr_count
    series=series
    title="Median New-Hire PRs vs Local Benchmark PR Levels"
    yFmt=num1
    yMin=0
    sort=false
    showAllXAxisLabels=true
    seriesOrder={['Median new-hire PRs', 'Median local benchmark', 'Median same-month benchmark']}
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">If raw PR volume rises but the new-hire line still sits well below the local benchmark, the issue is not just absolute output. It is that hires are still behind the normal pace for their local peer group.</p>

<Details title="Supporting context and diagnostics">
  <p><strong>Earlier watchpoint:</strong> <Value data={proposed_ramp_summary_cards} column=benchmark_by_day_60 fmt=pct1 /> at local benchmark by day `60`.</p>
  <p><strong>Eligible hires:</strong> <Value data={proposed_ramp_summary_cards} column=hires fmt=num0 />.</p>

  <DataTable data={proposed_ramp_curve}>
      <Column id=day_window_label title="Days Since Hire" />
      <Column id=fully_observed_hires title="Fully Observed Hires" fmt=num0 />
      <Column id=median_pct_of_contemporaneous_benchmark title="Median % Of Same-Month Benchmark" fmt=pct1 />
      <Column id=median_pct_of_pooled_benchmark title="Median % Of Pooled Benchmark" fmt=pct1 />
      <Column id=hit_local_benchmark_rate title="% Hitting Local Benchmark" fmt=pct1 />
  </DataTable>

  <p>Exact `0-29`, `30-59`, and `60-89` day windows avoid the old calendar-month distortion where late-month hires were structurally penalized in `ramp_month 0`.</p>

  <p>Cohort shape is a supporting lens only. Use it to see whether cohorts accumulate contribution at similar rates over time, not to override the local-benchmark read.</p>

  <LineChart
      data={proposed_ramp_cohort_cumulative_avg}
      x=day_window_label
      y=cumulative_avg_prs_per_hire
      series=cohort_month
      title="Cumulative Average PRs Per Hire By Cohort Month"
      yFmt=num1
      yMin=0
      sort=false
      showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>

  <p>The squad-share view is also diagnostic. It asks whether the median hire is taking a meaningful equal-share slice of local PR flow after adjusting for team size.</p>

  <LineChart
      data={proposed_ramp_share_curve}
      x=day_window_label
      y=median_local_team_pr_share_index
      title="Median Local Squad PR Share Index"
      yFmt=num2
      yMin=0
      sort=false
      showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>

  <DataTable data={proposed_ramp_segment_benchmarks}>
      <Column id=segment_type title="Segment Type" />
      <Column id=segment title="Segment" />
      <Column id=benchmark_pr_target title="Local Benchmark PRs / Month" fmt=num0 />
      <Column id=hires title="Hires" fmt=num0 />
      <Column id=median_days_to_benchmark title="Median Days to Local Benchmark" fmt=num0 />
      <Column id=benchmark_by_day_60 title="% At Local Benchmark By Day 60" fmt=pct1 />
      <Column id=benchmark_by_day_90 title="% At Local Benchmark By Day 90" fmt=pct1 />
  </DataTable>
</Details>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/proposed/ramp/decomposition">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Ramp Drivers →</span>
  </a>
</div>
