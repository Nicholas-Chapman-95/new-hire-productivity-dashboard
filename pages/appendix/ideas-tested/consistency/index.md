---
title: Consistency Lens
sidebar_position: 2
queries:
  - role_categories: dev/proposed_setup_role_categories.sql
  - employee_types: dev/proposed_setup_employee_types.sql
  - offices: dev/status_quo_offices.sql
  - levels: dev/status_quo_levels.sql
  - squads: dev/status_quo_squads.sql
  - sub_teams: dev/status_quo_sub_teams.sql
  - proposed_setup_summary_cards: dev/proposed_setup_summary_cards.sql
  - proposed_setup_summary_all: dev/proposed_setup_summary_all.sql
  - proposed_setup_grouped_summary: dev/proposed_setup_grouped_summary.sql
  - proposed_setup_trend: dev/proposed_setup_trend.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/appendix/ideas-tested">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Ideas Tested and Set Aside</span>
  </a>
</div>

<p class="eyebrow page-eyebrow">Appendix</p>
<p><strong>Current status:</strong> this spread view is useful as a supporting diagnostic, but it no longer needs to sit as a main page in the proposed operating model because the core consistency ideas have been rolled into setup and ramp interpretation.</p>
<p class="appendix-backlink"><a href="/appendix/ideas-tested">Back to ideas tested and set aside</a></p>
<p class="mini-caption">This route is the archived deep dive behind the <a href="/appendix/ideas-tested#1-consistency-is-useful-but-not-a-separate-kpi">consistency decision log entry</a>.</p>

<p>Default scope: valid onboarding cases only, <code>Software Engineering</code> hires, <code>Permanent</code> employees.</p>

<Grid cols=3>
<div>
<p><strong>Role Category</strong></p>
<Dropdown data={role_categories} name=role_productivity_category defaultValue="Software Engineering">
  <DropdownOption value="%" valueLabel="All Included Roles" />
</Dropdown>
</div>

<div>
<p><strong>Employee Type</strong></p>
<Dropdown data={employee_types} name=employee_type defaultValue="Permanent">
  <DropdownOption value="%" valueLabel="All Employee Types" />
</Dropdown>
</div>

<div>
<p><strong>Office</strong></p>
<Dropdown data={offices} name=office>
  <DropdownOption value="%" valueLabel="All Offices" />
</Dropdown>
</div>

<div>
<p><strong>Level</strong></p>
<Dropdown data={levels} name=management_level>
  <DropdownOption value="%" valueLabel="All Levels" />
</Dropdown>
</div>

<div>
<p><strong>Squad</strong></p>
<Dropdown data={squads} name=squad>
  <DropdownOption value="%" valueLabel="All Squads" />
</Dropdown>
</div>

<div>
<p><strong>Sub-Team</strong></p>
<Dropdown data={sub_teams} name=sub_team>
  <DropdownOption value="%" valueLabel="All Sub-Teams" />
</Dropdown>
</div>
</Grid>

<div style="display:none;">
<Dropdown name=day_basis defaultValue="calendar">
  <DropdownOption value="calendar" valueLabel="Calendar Days" />
</Dropdown>
</div>

<div class="metric-strip metric-strip--centered">
  <BigValue data={proposed_setup_summary_cards} value=hires title="Valid Hires" fmt=num0 />
  <BigValue data={proposed_setup_summary_cards} value=p25_days_to_first_pr title="P25 Days" fmt=num1 />
  <BigValue data={proposed_setup_summary_cards} value=median_days_to_first_pr title="Median Days" fmt=num1 />
  <BigValue data={proposed_setup_summary_cards} value=p75_days_to_first_pr title="P75 Days" fmt=num1 />
  <BigValue data={proposed_setup_summary_cards} value=iqr_days_to_first_pr title="IQR Days" fmt=num1 />
</div>

<p class="mini-caption">This is the consistency read in one line. The median gives the typical onboarding path. The <code>IQR</code> shows how much that experience varies for the middle half of hires.</p>

<div class="section-intro">
  <h2>Where is onboarding predictable vs unstable?</h2>
  <p>In the default scope, the strongest stable comparison cut is <strong>level</strong>. <strong>L5</strong> is the tightest broad group at <code>n=22</code> with an <code>IQR</code> of about <code>7.8</code> days, while <strong>L4</strong> is materially wider at <code>n=14</code> and about <code>17.8</code> days. Squad cuts are more diagnostic than office, but they get sparse fast: among squads with at least five hires, <strong>Granite</strong> is very tight while <strong>Delta</strong> is the widest current spread.</p>
</div>

<div class="feature-panel">
  <h2>Cohort percentile band</h2>
  <p>This is the operating trend read. Use the distance between <code>P25</code> and <code>P75</code> as the predictability signal, then check monthly <code>n</code> before treating a spike as a process change.</p>

  <Grid cols=2>
    <Group>
      <LineChart
          data={proposed_setup_summary_all}
          x=cohort_date
          y=days
          series=series
          title="Days to first PR by cohort month"
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
      <p class="mini-caption">Read the percentile band first. July `2025` and October `2025` show the widest recent spread, but both should be checked against cohort size before treating them as process breaks.</p>
    </Group>

    <Group>
      <BarChart
          data={proposed_setup_trend}
          x=cohort_month
          y=hires
          title="Cohort size (n) by month"
          fillColor="#355c7d"
          sort=false
          yFmt=num0
          yMin=0
          xLabelWrap=true
          showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>
      <p class="mini-caption">Wide bands with very small monthly cohorts are warning signals, not clean headline findings.</p>
    </Group>
  </Grid>
</div>

<div class="feature-panel">
  <h2>Level comparison: tight vs wide spread</h2>
  <p>This is the best current broad cut for answering the reliability question. It shows where the onboarding experience is clustered tightly enough to be predictable versus where it is much more uneven.</p>

  <Dropdown name=breakdown_by defaultValue=level>
    <DropdownOption value="office" valueLabel="Office" />
    <DropdownOption value="level" valueLabel="Level" />
    <DropdownOption value="sub_team" valueLabel="Sub-Team" />
    <DropdownOption value="squad" valueLabel="Squad" />
  </Dropdown>

  <Grid cols=2>
    <Group>
      <BarChart
          data={proposed_setup_grouped_summary}
          x=group_label
          y=iqr_days_to_first_pr
          title="IQR days to first PR by selected cut"
          fillColor="#2a9d8f"
          sort=false
          yFmt=num1
          yMin=0
          xLabelWrap=true
          showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>
      <p class="mini-caption">Tighter bars mean the middle half of hires land in a narrower range. Wider bars mean the median is less representative of the actual onboarding path.</p>
    </Group>

    <Group>
      <DataTable data={proposed_setup_grouped_summary}>
        <Column id=group_label title="Group" />
        <Column id=hires title="n" fmt=num0 />
        <Column id=p25_days_to_first_pr title="P25" fmt=num1 />
        <Column id=median_days_to_first_pr title="Median" fmt=num1 />
        <Column id=p75_days_to_first_pr title="P75" fmt=num1 />
        <Column id=iqr_days_to_first_pr title="IQR" fmt=num1 />
      </DataTable>
    </Group>
  </Grid>
</div>

<div class="priority-panel">
  <h2>Decision use</h2>
  <p>If median setup time looks acceptable but the percentile band stays wide, the problem is not a slow center. It is an onboarding path that works for some hires and fails to repeat reliably for others.</p>
</div>

<Details title="Support: reporting design and open questions">
  <p><strong>Suggested default metrics:</strong> <code>P25</code>, <code>P50</code>, <code>P75</code>, cohort size, and threshold completion rates such as <code>% reaching first PR by 30 days</code> or <code>% reaching central work by 60 / 90 days</code>.</p>
  <p><strong>Reporting guardrails:</strong> always show <code>n</code> on grouped views, de-emphasize very small groups, and avoid presenting fine-grained team cuts as equally stable when sample sizes differ sharply.</p>
  <p><strong>Open design question:</strong> this page may eventually need both percentile-band views and threshold-completion views, but the percentile read should stay primary because it explains whether the median is trustworthy.</p>
</Details>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/appendix/ideas-tested">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Ideas Tested and Set Aside →</span>
  </a>
</div>
