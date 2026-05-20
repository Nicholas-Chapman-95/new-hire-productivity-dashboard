---
title: Drivers
sidebar_position: 1
queries:
  - proposed_ramp_decomposition_summary: dev/proposed_ramp_decomposition_summary.sql
  - proposed_ramp_decomposition_curve: dev/proposed_ramp_decomposition_curve.sql
  - proposed_ramp_decomp_top_driver_candidates: dev/proposed_ramp_decomp_top_driver_candidates.sql
  - proposed_ramp_decomp_top_driver_annotations: dev/proposed_ramp_decomp_top_driver_annotations.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/proposed/ramp">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Ramp</span>
  </a>
</div>

We should watch the groups that stay weak in `30-59` and `60-89` and still have a low share hitting the local benchmark by `day 90`.

- `30-59` and `60-89` are the key ramp windows after initial setup.
- The watchlist compares `office`, `level`, `sub-team`, and `squad` on that same read.

## Ramp Shape

<Grid cols=2>
<div>
<p><strong>Break Down By</strong></p>
<Dropdown name=breakdown_by defaultValue=office>
  <DropdownOption value="office" valueLabel="Office" />
  <DropdownOption value="level" valueLabel="Level" />
  <DropdownOption value="sub_team" valueLabel="Sub-Team" />
  <DropdownOption value="squad" valueLabel="Squad" />
</Dropdown>
</div>
</Grid>

<Tabs id="ramp-driver-shape" fullWidth=true background=true>
  <Tab label="Raw PR Pace">
    <LineChart
        data={proposed_ramp_decomposition_curve}
        x=day_window_label
        y=median_pr_count
        series=group_label
        title="Ramp progression by group: median PRs"
        yFmt=num1
        yMin=0
        sort=false
        showAllXAxisLabels=true
      xAxisTitle=true
      yAxisTitle=true
/>

    <p class="mini-caption">A gap in `0-29` or `30-59` points to an early onboarding difference. A gap that persists through `60-89` and later windows points to a broader ramp-consistency problem rather than setup alone.</p>
  </Tab>

  <Tab label="Benchmark Hit Rate">
    <LineChart
        data={proposed_ramp_decomposition_curve}
        x=day_window_label
        y=hit_local_benchmark_rate
        series=group_label
        title="Ramp progression by group: % hitting local benchmark"
        yFmt=num1
        yMin=0
        yMax=100
        sort=false
        showAllXAxisLabels=true
      xAxisTitle=true
      yAxisTitle=true
/>

    <p class="mini-caption">A flat or lagging hit-rate curve means the group is not catching up to normal local peer pace as the ramp progresses.</p>
    <p class="mini-caption">We should still read this against the raw pace view. If a local office or squad is underperforming overall, a new hire can hit that local benchmark without actually reaching a strong absolute pace.</p>
  </Tab>
</Tabs>

## Primary Findings

- <Value data={proposed_ramp_decomp_top_driver_annotations} column=top_1_factor /> is the weakest current watchlist group on the combined ramp read.
- <Value data={proposed_ramp_decomp_top_driver_annotations} column=top_2_factor /> and <Value data={proposed_ramp_decomp_top_driver_annotations} column=top_3_factor /> are the next groups to watch.
- If a group is weak in `30-59` and `60-89` and also has a low `day 90` benchmark hit rate, that is a stronger ramp problem than low early pace alone.

## Cross-Dimension Watchlist

This table compares `office`, `level`, `sub-team`, and `squad` on the same three-part watchlist read.

<DataTable data={proposed_ramp_decomp_top_driver_candidates}>
    <Column id=driver_rank title="Rank" fmt=num0 />
    <Column id=factor_label title="Factor" />
    <Column id=median_prs_30_59 title="Median PRs, 30-59" fmt=num1 />
    <Column id=median_prs_60_89 title="Median PRs, 60-89" fmt=num1 />
    <Column id=benchmark_by_day_90 title="% Hitting Local Benchmark By Day 90" fmt=num1 />
    <Column id=hires title="Hires" fmt=num0 />
</DataTable>

<p class="mini-caption">This is a watchlist, not a causal decomposition. It shows which groups look weakest on the combined ramp read and deserve closer inspection.</p>

<Details title="Show selected slice detail">
  <DataTable data={proposed_ramp_decomposition_summary}>
      <Column id=group_label title="Group" />
      <Column id=hires title="Hires" fmt=num0 />
      <Column id=median_prs_30_59 title="Median PRs, 30-59" fmt=num1 />
      <Column id=benchmark_by_day_90 title="% Hitting Local Benchmark By Day 90" fmt=num1 />
      <Column id=median_prs_60_89 title="Median PRs, 60-89" fmt=num1 />
      <Column id=median_days_to_benchmark title="Median Days to Benchmark" fmt=num1 />
  </DataTable>

  <p class="mini-caption">If a group is low on raw pace but not low on `day 90` attainment, the issue is more likely about early shape than overall ramp sufficiency. If it is weak on both, that is a stronger ramp problem.</p>
</Details>

<Details title="Show full by-window benchmark detail">
  <DataTable data={proposed_ramp_decomposition_summary}>
      <Column id=group_label title="Group" />
      <Column id=hires title="Hires" fmt=num0 />
      <Column id=driver_signal title="Driver Signal" />
      <Column id=median_prs_0_29 title="Median PRs, 0-29" fmt=num1 />
      <Column id=median_prs_30_59 title="Median PRs, 30-59" fmt=num1 />
      <Column id=median_prs_60_89 title="Median PRs, 60-89" fmt=num1 />
      <Column id=median_prs_90_119 title="Median PRs, 90-119" fmt=num1 />
      <Column id=median_prs_120_149 title="Median PRs, 120-149" fmt=num1 />
      <Column id=median_prs_150_179 title="Median PRs, 150-179" fmt=num1 />
      <Column id=median_days_to_benchmark title="Median Days to Benchmark" fmt=num1 />
      <Column id=benchmark_by_day_60 title="% At Benchmark By Day 60" fmt=num1 />
      <Column id=benchmark_by_day_90 title="% Hitting Local Benchmark By Day 90" fmt=num1 />
  </DataTable>
</Details>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/proposed/recommendations">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Recommendations →</span>
  </a>
</div>
