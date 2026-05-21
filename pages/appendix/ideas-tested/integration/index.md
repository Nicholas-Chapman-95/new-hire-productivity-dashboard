---
title: Integration
sidebar_position: 3
queries:
  - role_categories: dev/proposed_setup_role_categories.sql
  - employee_types: dev/proposed_setup_employee_types.sql
  - offices: dev/status_quo_offices.sql
  - levels: dev/status_quo_levels.sql
  - squads: dev/status_quo_squads.sql
  - integration_milestones_by_office: dev/integration_milestones_by_office.sql
  - milestone_comparison_by_squad: dev/milestone_comparison_by_squad.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/appendix/ideas-tested">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Ideas Tested and Set Aside</span>
  </a>
</div>

<p class="eyebrow page-eyebrow">Appendix</p>
<p><strong>Current status:</strong> the repo-based <code>core</code> / <code>central work</code> proxies are directionally interesting, but not clean enough to support a confident KPI or a clear management finding.</p>

<p class="appendix-backlink"><a href="/appendix/ideas-tested">Back to ideas tested and set aside</a></p>
<p class="mini-caption">This route is the archived deep dive behind the <a href="/appendix/ideas-tested#2-the-integration-proxy-is-interesting-but-not-defensible-enough">integration-proxy decision log entry</a>.</p>

<div class="section-intro">
  <h2>Integration Proxy</h2>
  <p>This proxy tests whether first PR understates entry into team-central work. The gap is interesting, but the repo definition is not strong enough to support a KPI.</p>
</div>

> Default scope: valid onboarding cases only, `Software Engineering` hires, `Permanent` employees.

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
</div>

## Filters

<Grid cols=3>
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
</Grid>

<div class="metric-strip">
  <Grid cols=3>
    <div>
      <p><strong>What we tested</strong></p>
      <p>Compare <code>First PR</code> to <code>Core Repo PR</code>. The distance between them is the candidate integration lag.</p>
    </div>
    <div>
      <p><strong>What we hoped to learn</strong></p>
      <p>A stable, credible gap would suggest hires move from initial unblock into team-owned work later than the first-PR metric implies.</p>
    </div>
    <div>
      <p><strong>Why it did not advance</strong></p>
      <p>The repo definitions are still too loose to prove that this gap consistently represents entry into genuinely central work.</p>
    </div>
  </Grid>
</div>

<div class="feature-panel">
  <h2>What the current proxy shows</h2>
  <p>This view uses the current squad-core repo milestone as a working proxy for <code>central work</code>. In some cuts, hires reach a first PR earlier than they reach the proxy milestone, but the definition is still too loose for that gap to count as a settled finding.</p>

  <LineChart
      data={integration_milestones_by_office}
      x=office
      y=days
      series=milestone
      title="Median Days to First PR vs First Core-Repo PR"
      yFmt=num1
      yMin=0
      sort=false
      markers=true
      lineWidth=2
      showAllXAxisLabels=true
      seriesOrder={['First PR', 'Core Repo PR']}
      seriesColors={{
        'First PR': '#1f5f8b',
        'Core Repo PR': '#c46f4f'
      }}
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">Treat this as exploratory signal only, not as validated evidence of entry into central work.</p>
</div>

## Office Read

<DataTable data={integration_milestones_by_office}>
    <Column id=office title="Office" />
    <Column id=hires title="Hires" fmt=num0 />
    <Column id=milestone title="Milestone" />
    <Column id=days title="Median Days" fmt=num1 />
    <Column id=integration_gap_days title="Gap vs First PR" fmt=num1 />
</DataTable>

<p class="mini-caption">Differences here may help target follow-up work, but they are not strong enough to anchor a recommended KPI.</p>

## Squad Drilldown

<DataTable data={milestone_comparison_by_squad}>
    <Column id=squad title="Squad" />
    <Column id=hires title="Hires" fmt=num0 />
    <Column id=milestone title="Milestone" />
    <Column id=days title="Median Days" fmt=num1 />
    <Column id=integration_gap_days title="Gap vs First PR" fmt=num1 />
</DataTable>

<p class="mini-caption">Squad cuts get sparse quickly and inherit the same proxy-definition problem.</p>

<div class="priority-panel">
  <h2>Current decision</h2>
  <p>Do not treat this page as part of the recommended replacement metric set. It records a plausible direction that is not yet defensible enough to operationalize.</p>
</div>

<Details title="Support: working definition and unresolved design points">
  <p><strong>Working definition:</strong> this page currently uses first PR in a <code>tier_3</code> or squad-core repo as the provisional integration milestone because it is the strongest verified local proxy already available in the data.</p>
  <p><strong>Main reason it was set aside:</strong> the current <code>ownership-core</code> logic is still too loose to treat as a final definition of <code>central work</code>. Some repos look squad-exclusive without being central to the squad&apos;s real contribution surface.</p>
  <p><strong>What would need to change:</strong> a more defensible area-of-work definition, clearer evidence that the milestone behaves consistently across teams, and a management interpretation that is stronger than the current setup and ramp reads.</p>
</Details>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/appendix/ideas-tested">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Ideas Tested and Set Aside →</span>
  </a>
</div>
