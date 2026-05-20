---
title: Employees
sidebar_position: 1
queries:
  - context_employees_summary_cards: dev/context_employees_summary_cards.sql
  - context_employees_office_mix_combined: dev/context_employees_office_mix_combined.sql
  - context_employees_level_mix_combined: dev/context_employees_level_mix_combined.sql
  - context_employees_role_mix_combined: dev/context_employees_role_mix_combined.sql
  - context_employees_squad_mix_combined: dev/context_employees_squad_mix_combined.sql
  - context_employees_hiring_trend: dev/context_employees_hiring_trend.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/context">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Context</span>
  </a>
</div>

This page gives the broader employee landscape behind the onboarding analysis.

> Scope: the first section uses `dim_employees`, which gives the broader employee landscape in the productivity data. The final trend uses `onboarding_summary` to show how new hires sit within that broader picture.

<Grid cols=4>
<BigValue data={context_employees_summary_cards} value=employees title="Employees" fmt=num0 />
<BigValue data={context_employees_summary_cards} value=active_employees title="Active Employees" fmt=num0 />
<BigValue data={context_employees_summary_cards} value=offices title="Offices" fmt=num0 />
<BigValue data={context_employees_summary_cards} value=squads title="Squads" fmt=num0 />
</Grid>

## Current Employee Landscape

<BarChart
    data={context_employees_office_mix_combined}
    x=office
    y=value
    series=metric
    title="Current employee count and recent hiring by office"
    sort=false
    yFmt=num0
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    seriesOrder={['Current employees', 'New hires in last 12 months']}
    seriesColors={{
      'Current employees': '#2a9d8f',
      'New hires in last 12 months': '#3d405b'
    }}
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">This keeps the office picture on one axis: where the employee base sits now, and which offices contribute the largest recent hiring slice inside that footprint.</p>

<BarChart
    data={context_employees_level_mix_combined}
    x=level_label
    y=value
    series=metric
    title="Current employee count and recent hiring by level"
    sort=false
    yFmt=num0
    yMin=0
    seriesOrder={['Current employees', 'New hires in last 12 months']}
    seriesColors={{
      'Current employees': '#2a9d8f',
      'New hires in last 12 months': '#3d405b'
    }}
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">The level view now shows the same breakdown directly: which seniority bands are largest overall, and how much of each band comes from the most recent hiring wave.</p>

<BarChart
    data={context_employees_role_mix_combined}
    x=role_productivity_category
    y=value
    series=metric
    title="Current employee count and recent hiring by role productivity category"
    sort=false
    yFmt=num0
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    seriesOrder={['Current employees', 'New hires in last 12 months']}
    seriesColors={{
      'Current employees': '#2a9d8f',
      'New hires in last 12 months': '#3d405b'
    }}
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">This makes the role mix easier to compare with the squad view below: the base population stays visible, but the recent hiring portion is now explicit instead of implied.</p>

## Where People Sit In The Org

<BarChart
    data={context_employees_squad_mix_combined}
    x=squad
    y=value
    series=metric
    title="Current employee count and recent hiring by squad"
    sort=false
    yFmt=num0
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    seriesOrder={['Current employees', 'New hires in last 12 months']}
    seriesColors={{
      'Current employees': '#2a9d8f',
      'New hires in last 12 months': '#3d405b'
    }}
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">This puts current squad footprint and recent hiring on the same axis. It is easier to see which squads are large overall versus which are hiring more actively relative to their size.</p>

## New Hires Within That Broader Landscape

<LineChart
    data={context_employees_hiring_trend}
    x=cohort_date
    y=hires
    series=role_productivity_category
    title="Hiring over time by role productivity category"
    yFmt=num0
    yMin=0
    markers=true
    lineWidth=2
    seriesColors={{
      'Software Engineering': '#355c7d',
      'Technical Adjacent': '#8d6a9f',
      'Product': '#c06c84',
      'Non-Technical': '#7b8794'
    }}
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">This broader employee view helps explain why later onboarding and ramp comparisons need to stay explicit about which population they are using.</p>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/context/prs">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">PRs →</span>
  </a>
</div>
