---
title: Drivers
sidebar_position: 1
queries:
  - proposed_setup_story_h1_h2: dev/proposed_setup_story_h1_h2.sql
  - proposed_setup_grouped_summary: dev/proposed_setup_grouped_summary.sql
  - proposed_setup_decomp_top_driver_candidates_pct30: dev/proposed_setup_decomp_top_driver_candidates_pct30.sql
  - proposed_setup_decomp_top_driver_chart_pct30: dev/proposed_setup_decomp_top_driver_chart_pct30.sql
  - proposed_setup_decomp_top_driver_candidates_pct30_upward: dev/proposed_setup_decomp_top_driver_candidates_pct30_upward.sql
  - proposed_setup_decomp_top_driver_candidates_pct30_downward: dev/proposed_setup_decomp_top_driver_candidates_pct30_downward.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/proposed/setup">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Setup</span>
  </a>
</div>

Use this page to see where the bounded `% with first PR by day 30` setup KPI is weaker overall.

- Start with `office`. It is the safest default cut because it is easier to interpret than `squad` and usually less sparse than narrower organisational slices.
- Use the broad breakdown first. Period-comparison and contribution checks are supporting context only when there is a real movement to explain.

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

## Overall Drivers

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

<BarChart
    data={proposed_setup_grouped_summary}
    x=group_label
    y=pct_within_30_days
    title="% with first PR by day 30 by group"
    fillColor="#355c7d"
    sort=false
    xOrder={inputs.breakdown_by.value === 'level' ? ['L3', 'L4', 'L5', 'L6', 'L7'] : undefined}
    yFmt=num1
    yMin=0
    yMax=100
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle="% with first PR by day 30"
/>

<ul>
  <li>Higher bars mean a larger share of observed hires merged a first PR within 30 days.</li>
  <li>Lower bars mean weaker setup completion on the main KPI.</li>
  <li>Check `30-Day Observed` in the detail table before over-reading small groups.</li>
</ul>

<p class="mini-caption">This is the broad KPI read, not a contribution chart. Use it to see which groups have a lower or higher share of hires reaching a first PR by day 30 before asking what changed between periods.</p>

<Details title="Show overall driver table">
  <DataTable data={proposed_setup_grouped_summary}>
      <Column id=group_label title="Factor" />
      <Column id=observed_completion_hires title="30-Day Observed" fmt=num0 />
      <Column id=pct_within_30_days title="% Within 30 Days" fmt=num1 />
      <Column id=median_days_to_first_pr title="Median Days" fmt=num1 />
      <Column id=average_days_to_first_pr title="Mean Days" fmt=num1 />
  </DataTable>
</Details>

<Details title="Show period comparison and contribution check">
  <p>Period comparison is useful when the setup KPI changes over time and we need to see which factors are contributing to that change.</p>
  <p>This comparison is supporting context only. The six-month windows are close together here, so we should not force a strong movement story unless the topline clearly shifts.</p>
  <p class="mini-caption">We should not treat the slowest overall office as automatically the driver when we compare one period with another.</p>

  <BarChart
      data={proposed_setup_story_h1_h2}
      x=period
      y=pct_within_threshold
      title="% with first PR by day 30 by observed six-month window"
      fillColor="#355c7d"
      sort=false
      yFmt=num1
      yMin=0
      yMax=100
      xLabelWrap=true
      showAllXAxisLabels=true
      xAxisTitle=true
      yAxisTitle="% with first PR by day 30"
  />

  <ul>
    <li>The comparison is `2025-03 to 2025-08` versus `2025-09 to 2026-02`.</li>
    <li>Use this only when the topline movement is large enough to need explanation.</li>
  </ul>

  <BarChart
      data={proposed_setup_decomp_top_driver_chart_pct30}
      x=factor_label
      y=total_contribution
      title="Largest contributors to the six-month completion-rate movement"
      fillColor="#2a9d8f"
      sort=false
      yFmt=num2
      xLabelWrap=true
      showAllXAxisLabels=true
      xAxisTitle=true
      yAxisTitle="Contribution to the completion-rate gap (+ higher completion, - lower completion)"
  />

  <ul>
    <li>Positive contributions lift the later-period completion rate; negative contributions pull it down.</li>
    <li>This ranking compares candidate factors from several organisational cuts: `office`, `level`, `sub-team`, and `squad`.</li>
    <li>A large contribution can come from cohort mix, a changed group completion rate, or both.</li>
  </ul>

  <p class="mini-caption">Read this as a candidate-factor ranking, not as additive shares across cuts. The same hires can appear in office, level, sub-team, and squad rows, and very small cuts are follow-up checks rather than default conclusions.</p>

  <Details title="Show full ranked contribution detail">
  <BarChart
      data={proposed_setup_decomp_top_driver_candidates_pct30}
      x=factor_label
      y=total_contribution
      title="Largest contribution to the six-month completion-rate movement"
      fillColor="#2a9d8f"
      sort=false
      yFmt=num2
      xLabelWrap=true
      showAllXAxisLabels=true
      xAxisTitle=true
      yAxisTitle="Contribution to the completion-rate gap (+ higher completion, - lower completion)"
  />
  </Details>

  <p class="mini-caption">A relatively strong group can still contribute negatively if its completion rate falls or its cohort mix shifts unfavourably.</p>

  <Details title="Show ranked driver detail">
    <DataTable data={proposed_setup_decomp_top_driver_candidates_pct30}>
        <Column id=dimension_label title="Cut" />
        <Column id=group_label title="Factor" />
        <Column id=reference_hires title="Mar-Aug Hires" fmt=num0 />
        <Column id=selected_hires title="Sep-Feb Hires" fmt=num0 />
        <Column id=reference_metric_value title="Mar-Aug % Within 30 Days" fmt=num1 />
        <Column id=selected_metric_value title="Sep-Feb % Within 30 Days" fmt=num1 />
        <Column id=mix_component title="Mix Effect" fmt=num2 />
        <Column id=rate_component title="Rate Effect" fmt=num2 />
        <Column id=total_contribution title="Total Contribution" fmt=num2 />
    </DataTable>
  </Details>
</Details>

<p class="mini-caption">Additional drilldowns, office-by-office comparison tables, monthly consistency views, and ranked follow-ups are preserved in the <a href="/appendix/setup-drivers">Setup Drivers Appendix</a>. Cross-office squad investigation is also summarised in <a href="/appendix/ideas-tested/cross-office-squads">Cross-Office Squads</a>.</p>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/proposed/ramp">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Ramp →</span>
  </a>
</div>
