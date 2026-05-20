---
title: Status Quo
sidebar_position: 1
queries:
  - status_quo_scorecards: dev/status_quo_scorecards.sql
  - status_quo_first_pr_scatter: dev/status_quo_first_pr_scatter.sql
  - status_quo_first_pr_summary_cards: dev/status_quo_first_pr_summary_cards.sql
  - status_quo_first_pr_summary_all: dev/status_quo_first_pr_summary_all.sql
  - status_quo_detail_table: dev/status_quo_detail_table.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Onboarding Reliability Dashboard</span>
  </a>
</div>

<p class="eyebrow">Legacy Metric</p>

<div class="status-quo-intro">
  <ul class="status-quo-list">
    <li><strong>Objective:</strong> measure how quickly new engineers become productive after joining.</li>
    <li><strong>Historical metric:</strong> <code>time to first PR</code> = days between hire date and first merged pull request.</li>
    <li><strong>Scope:</strong> observable onboarding cases in <code>Software Engineering</code>. See <a href="/status-quo/metric-validity">Metric Validity</a>.</li>
  </ul>
</div>

<div style="display:none;">
<Dropdown name=role_productivity_category defaultValue="Software Engineering">
  <DropdownOption value="Software Engineering" valueLabel="Software Engineering" />
</Dropdown>

<Dropdown name=employee_type defaultValue="Permanent">
  <DropdownOption value="Permanent" valueLabel="Permanent" />
</Dropdown>

<Dropdown name=management_level defaultValue="%">
  <DropdownOption value="%" valueLabel="All Levels" />
</Dropdown>

<Dropdown name=office defaultValue="%">
  <DropdownOption value="%" valueLabel="All Offices" />
</Dropdown>

<Dropdown name=team defaultValue="%">
  <DropdownOption value="%" valueLabel="All Teams" />
</Dropdown>

<Dropdown name=sub_team defaultValue="%">
  <DropdownOption value="%" valueLabel="All Sub-Teams" />
</Dropdown>

<Dropdown name=squad defaultValue="%">
  <DropdownOption value="%" valueLabel="All Squads" />
</Dropdown>
</div>

<Grid cols=4>
  <BigValue data={status_quo_scorecards} value=eligible_hires title="Eligible Hires" fmt=num0 />
  <BigValue data={status_quo_first_pr_summary_cards} value=average_days_to_first_pr title="Average Days" fmt=num1 />
  <BigValue data={status_quo_first_pr_summary_cards} value=median_days_to_first_pr title="Median Days" fmt=num1 />
  <BigValue data={status_quo_first_pr_summary_cards} value=p75_days_to_first_pr title="P75 Days" fmt=num1 />
</Grid>

<p class="mini-caption"><strong>Eligible hires</strong> are permanent software-engineering hires whose onboarding starts after PR tracking begins on <code>2025-03-01</code>.</p>

<div style="display:none;">
<Dropdown name=color_by defaultValue="office">
  <DropdownOption value="office" valueLabel="Office" />
  <DropdownOption value="level" valueLabel="Level" />
</Dropdown>
</div>

<Tabs id="status-quo-chart-view" fullWidth=true background=true>
  <Tab label="Individual Hires">
    <ScatterPlot
        data={status_quo_first_pr_scatter}
        x=hire_date_axis
        y=days_to_first_pr
        series=series_label
        title="Days to first PR by individual hire date"
        yFmt=num0
        seriesOrder={['L3', 'L4', 'L5', 'L6', 'L7', 'L8']}
        seriesColors={{
          'L3': '#c8d9cf',
          'L4': '#a9c6ba',
          'L5': '#7ea9a6',
          'L6': '#5c89a0',
          'L7': '#3f6d98',
          'L8': '#274c77'
        }}
    xAxisTitle=true
    yAxisTitle=true
/>
  </Tab>

  <Tab label="Cohort Trends">
    <LineChart
        data={status_quo_first_pr_summary_all}
        x=cohort_date
        y=days
        series=series
        title="Time to first PR by hire cohort month"
        yFmt=num0
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
    >
      <Callout
          x="2025-07-01"
          y=66
          color="warning"
          label="July 2025 widens sharply."
      />
      <Callout
          x="2025-04-01"
          y=29
          color="warning"
          label="April 2025 median jumps to 29."
      />
      <Callout
          x="2025-09-01"
          y=12
          color="positive"
          label="September 2025 falls back fast."
      />
    </LineChart>
  </Tab>
</Tabs>

<p class="mini-caption"><strong>Individual hires:</strong> each point is a hire. The x-axis is the date they joined; the y-axis is how many days later their first PR was merged.</p>

<p class="mini-caption"><strong>Cohort trends:</strong> each month groups hires by the month they joined, not the month their first PR was merged.</p>

<ul class="status-quo-list status-quo-list-compact">
  <li>April <code>2025</code>: median jumps.</li>
  <li>July <code>2025</code>: spread widens materially.</li>
  <li>September <code>2025</code>: the metric improves abruptly.</li>
</ul>

<blockquote class="status-quo-reading-note">
  <p><strong>Reading note:</strong> Over time, the metric moves in ways that are <span class="status-quo-highlight">hard to square with a real onboarding process</span>. Some cohorts look unexpectedly slow, then the metric improves abruptly.</p>
</blockquote>

<Details title="Supporting detail">
  <p>The supporting table stays limited to status-quo fields tied directly to the legacy metric.</p>

  <DataTable data={status_quo_detail_table}>
      <Column id=hire_date title="Hire Date" />
      <Column id=cohort_month title="Cohort" />
      <Column id=office title="Office" />
      <Column id=management_level title="Level" />
      <Column id=team title="Team" />
      <Column id=sub_team title="Sub-Team" />
      <Column id=squad title="Squad" />
      <Column id=days_to_first_pr title="Days to First PR" fmt=num0 />
  </DataTable>
</Details>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/status-quo/metric-validity">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Metric Validity →</span>
  </a>
</div>
