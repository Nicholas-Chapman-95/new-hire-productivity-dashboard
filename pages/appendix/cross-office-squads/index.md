---
title: Cross-Office Squads
sidebar_position: 6
queries:
  - appendix_setup_cross_office_squad_summary: dev/appendix_setup_cross_office_squad_summary.sql
  - appendix_setup_cross_office_london_tallinn: dev/appendix_setup_cross_office_london_tallinn.sql
  - appendix_setup_cross_office_squad_list: dev/appendix_setup_cross_office_squad_list.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/appendix/setup-drivers">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Setup Drivers Appendix</span>
  </a>
</div>

Cross-office squads are worth tracking, but this cut is not strong enough yet to become a default setup lens.

- In the current setup slice, cross-office squads do not look dramatically worse than single-office squads on `30-day first-PR completion`.
- Most of the observed cross-office setup population is still `London`, so this is not yet a clean office-balanced comparison.
- The flag is now available as an optional cut in `Setup > Drivers`, but it stays secondary rather than replacing the default office read.

## Setup Comparison

<BarChart
    data={appendix_setup_cross_office_squad_summary}
    x=squad_type
    y=pct_by_day_30
    title="30-day first-PR completion: cross-office vs single-office squads"
    fillColor="#355c7d"
    sort=false
    yFmt=num1
    yMin=0
    yMax=100
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>

<Details title="Show setup comparison table">
  <DataTable data={appendix_setup_cross_office_squad_summary}>
      <Column id=squad_type title="Squad Type" />
      <Column id=hires title="Hires" fmt=num0 />
      <Column id=observed_30d_hires title="30-Day Observed" fmt=num0 />
      <Column id=pct_by_day_30 title="% By Day 30" fmt=num1 />
      <Column id=median_days_to_first_pr title="Median Days" fmt=num1 />
      <Column id=mean_days_to_first_pr title="Mean Days" fmt=num1 />
  </DataTable>
</Details>

## London And Tallinn Read

<BarChart
    data={appendix_setup_cross_office_london_tallinn}
    x=office
    y=pct_by_day_30
    series=squad_type
    type=grouped
    title="30-day first-PR completion by office and squad type"
    yFmt=num1
    yMin=0
    yMax=100
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>

<Details title="Show London and Tallinn detail">
  <DataTable data={appendix_setup_cross_office_london_tallinn}>
      <Column id=office title="Office" />
      <Column id=squad_type title="Squad Type" />
      <Column id=hires title="Hires" fmt=num0 />
      <Column id=observed_30d_hires title="30-Day Observed" fmt=num0 />
      <Column id=pct_by_day_30 title="% By Day 30" fmt=num1 />
      <Column id=median_days_to_first_pr title="Median Days" fmt=num1 />
      <Column id=mean_days_to_first_pr title="Mean Days" fmt=num1 />
  </DataTable>
</Details>

## Cross-Office Squads In Scope

<DataTable data={appendix_setup_cross_office_squad_list}>
    <Column id=squad title="Squad" />
    <Column id=offices title="Observed Offices" />
    <Column id=office title="Office" />
    <Column id=hires title="Hires" fmt=num0 />
    <Column id=observed_30d_hires title="30-Day Observed" fmt=num0 />
    <Column id=pct_by_day_30 title="% By Day 30" fmt=num1 />
    <Column id=median_days_to_first_pr title="Median Days" fmt=num1 />
    <Column id=mean_days_to_first_pr title="Mean Days" fmt=num1 />
</DataTable>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/appendix/setup-holiday-adjustment">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Setup Holiday Adjustment →</span>
  </a>
</div>
