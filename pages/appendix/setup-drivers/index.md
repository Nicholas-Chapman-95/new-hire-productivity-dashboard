---
title: Setup Drivers Appendix
sidebar_position: 5
queries:
  - proposed_setup_story_monthly: dev/proposed_setup_story_monthly.sql
  - proposed_setup_story_offices: dev/proposed_setup_story_offices.sql
  - proposed_setup_story_july_cases: dev/proposed_setup_story_july_cases.sql
  - proposed_setup_level_period_avg: dev/proposed_setup_level_period_avg.sql
  - proposed_setup_overall_level_avg: dev/proposed_setup_overall_level_avg.sql
  - proposed_setup_overall_squad_avg: dev/proposed_setup_overall_squad_avg.sql
  - proposed_setup_bridge_jul_jun_level_avg: dev/proposed_setup_bridge_jul_jun_level_avg.sql
  - proposed_setup_bridge_jul_jun_squad_avg: dev/proposed_setup_bridge_jul_jun_squad_avg.sql
  - proposed_setup_bridge_h2_h1_level_avg: dev/proposed_setup_bridge_h2_h1_level_avg.sql
  - proposed_setup_decomp_top_driver_candidates: dev/proposed_setup_decomp_top_driver_candidates.sql
  - proposed_setup_decomp_overall_driver_candidates_slowest: dev/proposed_setup_decomp_overall_driver_candidates_slowest.sql
  - proposed_setup_decomp_overall_driver_candidates_fastest: dev/proposed_setup_decomp_overall_driver_candidates_fastest.sql
  - proposed_setup_decomp_top_driver_candidates_upward: dev/proposed_setup_decomp_top_driver_candidates_upward.sql
  - proposed_setup_decomp_top_driver_candidates_downward: dev/proposed_setup_decomp_top_driver_candidates_downward.sql
  - proposed_setup_monthly_level_pulls_avg: dev/proposed_setup_monthly_level_pulls_avg.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/appendix/ideas-tested">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Ideas Tested and Set Aside</span>
  </a>
</div>

Supporting detail for the `Setup` driver read. Use this only when the core `Drivers` page raises a follow-up question.

## Monthly Consistency

<Grid cols=2>
<LineChart
    data={proposed_setup_story_monthly}
    x=cohort_date
    y=avg_days
    y2=median_days
    y2SeriesType=line
    title="Monthly setup center: mean vs median days to first PR"
    yFmt=num1
    y2Fmt=num1
    yMin=0
    markers=true
    lineWidth=2
    seriesColors={['#2c7a7b', '#1f5f8b']}
    xAxisTitle=true
    yAxisTitle=true
/>

<LineChart
    data={proposed_setup_story_monthly}
    x=cohort_date
    y=pct_30
    y2=hires
    y2SeriesType=bar
    title="% within 30 days and cohort size by month"
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
</Grid>

<DataTable data={proposed_setup_story_monthly}>
    <Column id=cohort_month title="Cohort Month" />
    <Column id=hires title="Hires" fmt=num0 />
    <Column id=avg_days title="Mean Days" fmt=num1 />
    <Column id=median_days title="Median Days" fmt=num1 />
    <Column id=p25_days title="P25 Days" fmt=num1 />
    <Column id=p75_days title="P75 Days" fmt=num1 />
    <Column id=pct_30 title="% Within 30 Days" fmt=num1 />
</DataTable>

## Level Follow-Up

<Grid cols=2>
<BarChart
    data={proposed_setup_level_period_avg}
    x=level
    y=mean_days_to_first_pr
    series=period
    type=grouped
    title="Level mean days to first PR by observed six-month window"
    xOrder={['L3', 'L4', 'L5', 'L6', 'L7']}
    yFmt=num1
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>

<BarChart
    data={proposed_setup_bridge_h2_h1_level_avg}
    x=group_label
    y=total_contribution
    title="Level contribution to the six-month movement"
    fillColor="#c46f4f"
    sort=false
    xOrder={['L3', 'L4', 'L5', 'L6', 'L7']}
    yFmt=num2
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>
</Grid>

<DataTable data={proposed_setup_bridge_h2_h1_level_avg}>
    <Column id=group_label title="Level" />
    <Column id=reference_hires title="Mar-Aug Hires" fmt=num0 />
    <Column id=selected_hires title="Sep-Feb Hires" fmt=num0 />
    <Column id=reference_metric_value title="Mar-Aug Mean Days" fmt=num1 />
    <Column id=selected_metric_value title="Sep-Feb Mean Days" fmt=num1 />
    <Column id=mix_component title="Mix Effect" fmt=num2 />
    <Column id=rate_component title="Rate Effect" fmt=num2 />
    <Column id=total_contribution title="Total Contribution" fmt=num2 />
</DataTable>

## Ranked Candidates

<Tabs id="setup-driver-direction" fullWidth=true background=true>
  <Tab label="Biggest Upward Pulls">
    <DataTable data={proposed_setup_decomp_top_driver_candidates_upward}>
        <Column id=contribution_rank title="Rank" fmt=num0 />
        <Column id=dimension_label title="Cut" />
        <Column id=group_label title="Factor" />
        <Column id=reference_hires title="Mar-Aug Hires" fmt=num0 />
        <Column id=selected_hires title="Sep-Feb Hires" fmt=num0 />
        <Column id=reference_metric_value title="Mar-Aug Mean" fmt=num1 />
        <Column id=selected_metric_value title="Sep-Feb Mean" fmt=num1 />
        <Column id=total_contribution title="Total Pull" fmt=num2 contentType=bar barColor=#c46f4f backgroundColor=#f3ebe7 />
    </DataTable>
  </Tab>

  <Tab label="Biggest Offsets">
    <DataTable data={proposed_setup_decomp_top_driver_candidates_downward}>
        <Column id=contribution_rank title="Rank" fmt=num0 />
        <Column id=dimension_label title="Cut" />
        <Column id=group_label title="Factor" />
        <Column id=reference_hires title="Mar-Aug Hires" fmt=num0 />
        <Column id=selected_hires title="Sep-Feb Hires" fmt=num0 />
        <Column id=reference_metric_value title="Mar-Aug Mean" fmt=num1 />
        <Column id=selected_metric_value title="Sep-Feb Mean" fmt=num1 />
        <Column id=total_contribution title="Total Offset" fmt=num2 contentType=bar barColor=#7aa6a1 negativeBarColor=#2a9d8f backgroundColor=#e8f2f1 />
    </DataTable>
  </Tab>
</Tabs>

<Details title="Show mix and rate breakdown">
  <DataTable data={proposed_setup_decomp_top_driver_candidates}>
      <Column id=dimension_label title="Cut" />
      <Column id=group_label title="Factor" />
      <Column id=reference_hires title="Mar-Aug Hires" fmt=num0 />
      <Column id=selected_hires title="Sep-Feb Hires" fmt=num0 />
      <Column id=reference_metric_value title="Mar-Aug Mean Days" fmt=num1 />
      <Column id=selected_metric_value title="Sep-Feb Mean Days" fmt=num1 />
      <Column id=mix_component title="Mix Effect" fmt=num2 />
      <Column id=rate_component title="Rate Effect" fmt=num2 />
      <Column id=total_contribution title="Total Contribution" fmt=num2 />
  </DataTable>
</Details>

## Structural Detail

<Tabs id="setup-overall-driver-direction" fullWidth=true background=true>
  <Tab label="Slowest Overall">
    <DataTable data={proposed_setup_decomp_overall_driver_candidates_slowest}>
        <Column id=overall_rank title="Rank" fmt=num0 />
        <Column id=dimension_label title="Cut" />
        <Column id=group_label title="Factor" />
        <Column id=hires title="Hires" fmt=num0 />
        <Column id=mean_days_to_first_pr title="Mean Days" fmt=num1 contentType=bar barColor=#c46f4f backgroundColor=#f3ebe7 />
        <Column id=median_days_to_first_pr title="Median Days" fmt=num1 />
        <Column id=pct_within_30_days title="% In First Month" fmt=num1 />
    </DataTable>
  </Tab>

  <Tab label="Fastest Overall">
    <DataTable data={proposed_setup_decomp_overall_driver_candidates_fastest}>
        <Column id=overall_rank title="Rank" fmt=num0 />
        <Column id=dimension_label title="Cut" />
        <Column id=group_label title="Factor" />
        <Column id=hires title="Hires" fmt=num0 />
        <Column id=mean_days_to_first_pr title="Mean Days" fmt=num1 contentType=bar barColor=#2a9d8f backgroundColor=#e8f2f1 />
        <Column id=median_days_to_first_pr title="Median Days" fmt=num1 />
        <Column id=pct_within_30_days title="% In First Month" fmt=num1 />
    </DataTable>
  </Tab>
</Tabs>

<DataTable data={proposed_setup_overall_level_avg}>
    <Column id=level title="Level" />
    <Column id=hires title="Hires" fmt=num0 />
    <Column id=mean_days_to_first_pr title="Overall Mean Days" fmt=num1 />
    <Column id=median_days_to_first_pr title="Overall Median Days" fmt=num1 />
    <Column id=pct_within_30_days title="% Within 30 Days" fmt=num1 />
</DataTable>

<DataTable data={proposed_setup_overall_squad_avg}>
    <Column id=squad title="Squad" />
    <Column id=hires title="Hires" fmt=num0 />
    <Column id=mean_days_to_first_pr title="Overall Mean Days" fmt=num1 />
    <Column id=median_days_to_first_pr title="Overall Median Days" fmt=num1 />
    <Column id=pct_within_30_days title="% Within 30 Days" fmt=num1 />
</DataTable>

## Additional Investigative Detail

<DataTable data={proposed_setup_bridge_jul_jun_level_avg}>
    <Column id=group_label title="Level" />
    <Column id=reference_hires title="Jun Hires" fmt=num0 />
    <Column id=selected_hires title="Jul Hires" fmt=num0 />
    <Column id=reference_metric_value title="Jun Mean Days" fmt=num1 />
    <Column id=selected_metric_value title="Jul Mean Days" fmt=num1 />
    <Column id=mix_component title="Mix Effect" fmt=num2 />
    <Column id=rate_component title="Rate Effect" fmt=num2 />
    <Column id=total_contribution title="Total Contribution" fmt=num2 />
</DataTable>

<DataTable data={proposed_setup_bridge_jul_jun_squad_avg}>
    <Column id=group_label title="Squad" />
    <Column id=reference_hires title="Jun Hires" fmt=num0 />
    <Column id=selected_hires title="Jul Hires" fmt=num0 />
    <Column id=reference_metric_value title="Jun Mean Days" fmt=num1 />
    <Column id=selected_metric_value title="Jul Mean Days" fmt=num1 />
    <Column id=mix_component title="Mix Effect" fmt=num2 />
    <Column id=rate_component title="Rate Effect" fmt=num2 />
    <Column id=total_contribution title="Total Contribution" fmt=num2 />
</DataTable>

<DataTable data={proposed_setup_story_july_cases}>
    <Column id=level_label title="Level" />
    <Column id=sub_team title="Sub-Team" />
    <Column id=squad title="Squad" />
    <Column id=office title="Office" />
    <Column id=hires title="Hires" fmt=num0 />
    <Column id=avg_days title="Mean Days" fmt=num1 />
    <Column id=min_days title="Min Days" fmt=num1 />
    <Column id=max_days title="Max Days" fmt=num1 />
    <Column id=pct_30 title="% Within 30 Days" fmt=num1 />
</DataTable>

<BarChart
    data={proposed_setup_monthly_level_pulls_avg}
    x=cohort_label
    y=total_contribution
    series=group_label
    title="Monthly pulls on mean days to first PR by level"
    sort=false
    yFmt=num2
    xLabelWrap=false
    showAllXAxisLabels=true
    seriesOrder={['L3', 'L4', 'L5', 'L6', 'L7']}
    stack=true
    xAxisTitle=true
    yAxisTitle=true
/>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/appendix/ideas-tested/cross-office-squads">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Cross-Office Squads →</span>
  </a>
</div>
