---
title: Ideas Tested and Set Aside
sidebar_position: 1
queries:
  - appendix_investigated_summary: dev/appendix_investigated_summary.sql
  - appendix_investigated_context_correlations: dev/appendix_investigated_context_correlations.sql
  - appendix_investigated_milestones: dev/appendix_investigated_milestones.sql
  - appendix_investigated_squad_size_buckets: dev/appendix_investigated_squad_size_buckets.sql
  - appendix_investigated_same_time_buckets: dev/appendix_investigated_same_time_buckets.sql
  - context_prs_first_pr_repo_clustering: dev/context_prs_first_pr_repo_clustering.sql
  - role_categories: dev/proposed_setup_role_categories.sql
  - employee_types: dev/proposed_setup_employee_types.sql
  - offices: dev/status_quo_offices.sql
  - levels: dev/status_quo_levels.sql
  - squads: dev/status_quo_squads.sql
  - sub_teams: dev/status_quo_sub_teams.sql
  - proposed_setup_summary_cards: dev/proposed_setup_summary_cards.sql
  - proposed_setup_summary_all: dev/proposed_setup_summary_all.sql
  - proposed_setup_grouped_summary: dev/proposed_setup_grouped_summary.sql
  - integration_milestones_by_office: dev/integration_milestones_by_office.sql
  - milestone_comparison_by_squad: dev/milestone_comparison_by_squad.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/appendix">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Appendix</span>
  </a>
</div>

<p class="eyebrow page-eyebrow">Appendix</p>
<p><strong>Current status:</strong> this section records ideas we tested, what signal appeared, and why each one was set aside rather than promoted into the operating model.</p>

<p class="appendix-backlink"><a href="/appendix">Back to appendix overview</a></p>

<div style="display:none;">
<Dropdown data={role_categories} name=role_focus defaultValue="Software Engineering">
  <DropdownOption value="%" valueLabel="All Included Roles" />
</Dropdown>
<Dropdown data={role_categories} name=role_productivity_category defaultValue="Software Engineering">
  <DropdownOption value="%" valueLabel="All Included Roles" />
</Dropdown>
<Dropdown data={employee_types} name=employee_type defaultValue="Permanent">
  <DropdownOption value="%" valueLabel="All Employee Types" />
</Dropdown>
<Dropdown data={offices} name=office defaultValue="%">
  <DropdownOption value="%" valueLabel="All Offices" />
</Dropdown>
<Dropdown data={levels} name=management_level defaultValue="%">
  <DropdownOption value="%" valueLabel="All Levels" />
</Dropdown>
<Dropdown data={squads} name=squad defaultValue="%">
  <DropdownOption value="%" valueLabel="All Squads" />
</Dropdown>
<Dropdown data={sub_teams} name=sub_team defaultValue="%">
  <DropdownOption value="%" valueLabel="All Sub-Teams" />
</Dropdown>
<Dropdown name=breakdown_by defaultValue=level>
  <DropdownOption value="level" valueLabel="Level" />
</Dropdown>
<Dropdown name=day_basis defaultValue="calendar">
  <DropdownOption value="calendar" valueLabel="Calendar Days" />
</Dropdown>
</div>

Use this section when the question is `what else did we test?` or `why did this idea not make the cut?`

- [Consistency as a diagnostic, not a KPI](#1-consistency-is-useful-but-not-a-separate-kpi)
- [Repo-based integration proxy](#2-the-integration-proxy-is-interesting-but-not-defensible-enough)
- [Cadence and team-context hypotheses](#3-cadence-and-team-context-did-not-hold-up)
- [Other ideas checked and rejected](#4-other-ideas-checked-and-set-aside)

<p class="mini-caption"><strong>What advanced:</strong> <code>time to local benchmark</code> survived into the ramp framework, and exact <code>30-day</code> windows replaced calendar <code>ramp_month 0</code>.</p>

<div class="feature-panel">
  <h2>Investigation summary</h2>
  <p>The table below is the shortest complete answer: what was tested, what signal appeared, and why it stopped.</p>

  <DataTable data={appendix_investigated_summary}>
    <Column id=idea title="Idea" />
    <Column id=finding title="What We Found" />
    <Column id=why_not_advanced title="Why It Was Not Advanced" />
  </DataTable>

  <Details title="Full hypothesis and evidence log">
    <DataTable data={appendix_investigated_summary}>
      <Column id=idea title="Idea" />
      <Column id=hypothesis title="Hypothesis" />
      <Column id=evidence_used title="Evidence Used" />
      <Column id=finding title="Finding" />
      <Column id=why_not_advanced title="Why Not Advanced" />
    </DataTable>
  </Details>
</div>

## Deep Dives For Specific Rejected Ideas

Use these archived working pages only when a specific rejected idea needs more detail than the decision log.

- [Consistency Lens](/appendix/ideas-tested/consistency)
- [Integration](/appendix/ideas-tested/integration)
- [Cross-Office Squads](/appendix/ideas-tested/cross-office-squads)
- [Setup Holiday Adjustment](/appendix/ideas-tested/setup-holiday-adjustment)

<div class="feature-panel">
  <h2 id="1-consistency-is-useful-but-not-a-separate-kpi">1. Consistency is useful, but not a separate KPI</h2>
  <p>Spread helps interpret setup performance, but it does not need its own operating page because the same insight is stronger when attached directly to the setup and ramp reads.</p>

  <ul>
    <li>Use <code>P25</code>, <code>P50</code>, <code>P75</code>, and <code>IQR</code> to tell whether a slower result reflects a slower center, wider spread, or both.</li>
    <li>The signal is useful diagnostically, but it overlaps the current proposed pages instead of changing the recommendation.</li>
    <li>The deeper archived working page is still available at <a href="/appendix/ideas-tested/consistency">Consistency Lens</a>.</li>
  </ul>

  <div class="metric-strip metric-strip--centered">
    <BigValue data={proposed_setup_summary_cards} value=p25_days_to_first_pr title="P25 Days" fmt=num1 />
    <BigValue data={proposed_setup_summary_cards} value=median_days_to_first_pr title="Median Days" fmt=num1 />
    <BigValue data={proposed_setup_summary_cards} value=p75_days_to_first_pr title="P75 Days" fmt=num1 />
    <BigValue data={proposed_setup_summary_cards} value=iqr_days_to_first_pr title="IQR Days" fmt=num1 />
  </div>

  <LineChart
      data={proposed_setup_summary_all}
      x=cohort_date
      y=days
      series=series
      title="Setup percentile band by cohort month"
      yFmt=num1
      yMin=0
      markers=true
      lineWidth=2
      seriesOrder={['Median', 'P25', 'P75']}
      seriesColors={{
        'Median': '#1f5f8b',
        'P25': '#c46f4f',
        'P75': '#d39d68'
      }}
    xAxisTitle=true
    yAxisTitle=true
/>

  <Details title="Supporting spread table">
    <DataTable data={proposed_setup_grouped_summary}>
      <Column id=group_label title="Level" />
      <Column id=hires title="n" fmt=num0 />
      <Column id=p25_days_to_first_pr title="P25" fmt=num1 />
      <Column id=median_days_to_first_pr title="Median" fmt=num1 />
      <Column id=p75_days_to_first_pr title="P75" fmt=num1 />
      <Column id=iqr_days_to_first_pr title="IQR" fmt=num1 />
    </DataTable>
  </Details>
</div>

<div class="feature-panel">
  <h2 id="2-the-integration-proxy-is-interesting-but-not-defensible-enough">2. The integration proxy is interesting, but not defensible enough</h2>
  <p>First PR may understate true onboarding progress, but the current repo-based milestone is still too loosely defined to support a KPI or a strong management conclusion.</p>

  <ul>
    <li>The gap between <code>First PR</code> and <code>Core Repo PR</code> is directionally interesting.</li>
    <li>The weakness is construct quality, not absence of any signal.</li>
    <li>The deeper archived working page is still available at <a href="/appendix/ideas-tested/integration">Integration</a>.</li>
  </ul>

  <LineChart
      data={integration_milestones_by_office}
      x=office
      y=days
      series=milestone
      title="First PR vs core-repo milestone by office"
      yFmt=num1
      yMin=0
      markers=true
      lineWidth=2
      sort=false
      showAllXAxisLabels=true
      seriesOrder={['First PR', 'Core Repo PR']}
      seriesColors={{
        'First PR': '#1f5f8b',
        'Core Repo PR': '#c46f4f'
      }}
    xAxisTitle=true
    yAxisTitle=true
/>

  <Details title="Supporting repo-pattern table">
    <DataTable data={context_prs_first_pr_repo_clustering}>
      <Column id=squad title="Squad" />
      <Column id=hires title="Hires" fmt=num0 />
      <Column id=distinct_first_pr_repos title="Distinct First-PR Repos" fmt=num0 />
      <Column id=top_first_pr_repo_share_pct title="Top Repo Share %" fmt=num1 />
    </DataTable>
  </Details>
</div>

<div class="feature-panel">
  <h2 id="3-cadence-and-team-context-did-not-hold-up">3. Cadence and team context did not hold up</h2>
  <p>Larger squads and same-time same-squad cohorts do not show a stable enough relationship with setup or ramp to support a reliable management read.</p>

  <ul>
    <li>The correlations stay weak.</li>
    <li>The direction is not consistent enough to anchor an intervention.</li>
    <li>These cuts remain useful as ad hoc checks, not part of the operating model.</li>
  </ul>

  <div class="metric-strip metric-strip--centered">
    <BigValue data={appendix_investigated_context_correlations} value=corr_squad_size_setup title="Squad Size vs Setup" fmt=num2 />
    <BigValue data={appendix_investigated_context_correlations} value=corr_squad_size_ramp title="Squad Size vs Ramp" fmt=num2 />
    <BigValue data={appendix_investigated_context_correlations} value=corr_same_time_setup title="Same-Time vs Setup" fmt=num2 />
    <BigValue data={appendix_investigated_context_correlations} value=corr_same_time_ramp title="Same-Time vs Ramp" fmt=num2 />
  </div>

  <BarChart
      data={appendix_investigated_same_time_buckets}
      x=bucket_label
      y=median_days_to_first_pr
      title="Setup by nearby same-squad hires"
      fillColor="#355c7d"
      sort=false
      yFmt=num1
      yMin=0
      showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>
</div>

<div class="feature-panel">
  <h2 id="4-other-ideas-checked-and-set-aside">4. Other ideas checked and set aside</h2>
  <p>These ideas were worth testing, but none beat the final setup-plus-ramp framework strongly enough to deserve their own operating surface.</p>

  <p><strong>Supporting milestones</strong></p>
  <div class="metric-strip metric-strip--centered">
    <BigValue data={appendix_investigated_milestones} value=median_days_to_fifth_pr title="Median Days to 5th PR" fmt=num1 />
    <BigValue data={appendix_investigated_milestones} value=median_days_to_tenth_pr title="Median Days to 10th PR" fmt=num1 />
    <BigValue data={appendix_investigated_milestones} value=pct_to_fifth_by_60 title="% to 5th PR by Day 60" fmt=num1 />
    <BigValue data={appendix_investigated_milestones} value=pct_to_tenth_by_90 title="% to 10th PR by Day 90" fmt=num1 />
  </div>
  <p class="mini-caption">Useful bridge metrics, but too overlapping with the ramp story to justify a separate headline track.</p>

  <ul>
    <li>First-PR cycle time was checked as a possible friction read, but the signal was weak and timestamp validity issues limited confidence.</li>
    <li>Holiday-adjusted working days were checked, but they did not change the setup read enough to replace the calendar-day default. The useful finding was year-end PR seasonality instead, preserved at <a href="/appendix/ideas-tested/setup-holiday-adjustment">Setup Holiday Adjustment</a>.</li>
    <li>Permanent, intern, and <code>Other</code> employee types behave too differently to share one onboarding KPI.</li>
    <li><code>Fixed-Term</code> had no meaningful valid engineering onboarding sample in the reliability slice.</li>
    <li>Calendar <code>ramp_month 0</code> was tested and rejected because exact <code>30-day</code> windows are structurally fairer for late-month hires.</li>
    <li>Manager-hierarchy local-benchmark comparisons were explored, but the reporting lines were not clean enough in the available data to identify reliable hiring chains.</li>
    <li>Cross-office squads were checked as a setup hypothesis, but the current sample is still too office-skewed to justify a default lens. The preserved drilldown is at <a href="/appendix/ideas-tested/cross-office-squads">Cross-Office Squads</a>.</li>
  </ul>
</div>

<div class="priority-panel">
  <h2>Current decision</h2>
  <p>This page is the evidence trail for analytical breadth and disciplined rejection criteria. It is not part of the leadership KPI surface.</p>
</div>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/appendix/ideas-tested/consistency">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Consistency Lens →</span>
  </a>
</div>
