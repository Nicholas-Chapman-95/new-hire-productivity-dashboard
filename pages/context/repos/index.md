---
title: Repos
sidebar_position: 3
queries:
  - context_prs_repos_summary_cards: dev/context_prs_repos_summary_cards.sql
  - context_prs_repo_group_mix: dev/context_prs_repo_group_mix.sql
  - context_prs_top_repos: dev/context_prs_top_repos.sql
  - context_prs_repo_group_trend: dev/context_prs_repo_group_trend.sql
  - context_prs_squad_repo_groups: dev/context_prs_squad_repo_groups.sql
  - context_prs_squad_repo_group_flow: dev/context_prs_squad_repo_group_flow.sql
  - context_prs_sub_team_repo_group_flow: dev/context_prs_sub_team_repo_group_flow.sql
  - context_prs_new_hire_first_pr_flow: dev/context_prs_new_hire_first_pr_flow.sql
  - context_prs_first_pr_repo_clustering: dev/context_prs_first_pr_repo_clustering.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/context/prs">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← PRs</span>
  </a>
</div>

This page gives the repo landscape behind the onboarding analysis.

> Scope: all PRs in `fct_pull_requests`, which currently run from `2025-03-01` to `2026-03-30`.

<Grid cols=4>
<BigValue data={context_prs_repos_summary_cards} value=prs title="PRs" fmt=num0 />
<BigValue data={context_prs_repos_summary_cards} value=repos title="Repos" fmt=num0 />
<BigValue data={context_prs_repos_summary_cards} value=repo_groups title="Repo Groups" fmt=num0 />
<BigValue data={context_prs_repos_summary_cards} value=authors title="Authors" fmt=num0 />
</Grid>

## Repo Landscape

<BarChart
    data={context_prs_repo_group_mix}
    x=repo_group
    y=prs
    title="PR volume by repo group"
    fillColor="#355c7d"
    sort=false
    yFmt=num0
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>

<p class="mini-caption">PR volume is spread across several large repo groups rather than one dominant namespace. That matters when we later define what should count as a team's core or key repos.</p>

<LineChart
    data={context_prs_repo_group_trend}
    x=report_month
    y=prs
    series=repo_group
    title="Top repo groups over time"
    yFmt=num0
    yMin=0
    markers=true
    lineWidth=2
    seriesColors={{
      'soylent': '#355c7d',
      'cyberdyne': '#c06c84',
      'oscorp': '#6c5b7b',
      'globex': '#2a9d8f',
      'initech': '#e09f3e'
    }}
    xAxisTitle=true
    yAxisTitle=true
/>

## What People Contribute To

<DataTable data={context_prs_top_repos}>
    <Column id=pr_repository_name title="Repository" />
    <Column id=prs title="PRs" fmt=num0 />
</DataTable>

<p class="mini-caption">A small number of repos account for a large share of contribution volume. That is useful context for later questions about integration into meaningful work.</p>

## Squad To Repo-Group Patterns

<SankeyDiagram
    data={context_prs_squad_repo_group_flow}
    title="Engineering squad to repo-group contribution flow"
    sourceCol=source
    targetCol=target
    valueCol=value
    chartAreaHeight=500
/>

<p class="mini-caption">This is a first-pass flow view using permanent attributed PRs for engineering contributors only. It is useful for checking whether `squad` looks like the right level of granularity before we define team-specific `core repo` or `key repo` metrics.</p>

<SankeyDiagram
    data={context_prs_sub_team_repo_group_flow}
    title="Engineering sub-team to repo-group contribution flow"
    sourceCol=source
    targetCol=target
    valueCol=value
    chartAreaHeight=420
/>

<p class="mini-caption">`Sub-team` adds signal here in a way `team` does not. In practice, the useful contrast is mostly `Platform` versus `Security Team`, while `team` collapses to `Engineering` and adds very little.</p>

<SankeyDiagram
    data={context_prs_new_hire_first_pr_flow}
    title="New-hire first PR destination by squad"
    sourceCol=source
    targetCol=target
    valueCol=value
    chartAreaHeight=420
/>

<p class="mini-caption">This is the onboarding-specific version of the flow. It is narrower than the all-PR view and helps show where new hires tend to land first, which is more relevant for setup and integration questions.</p>

## Do Squads Reuse The Same First-PR Repos?

<p>Not strongly. Across the valid software-engineering onboarding cases, first PRs land in many different repos rather than one obvious shared onboarding destination.</p>

<ul>
  <li>`56` valid new hires land in `40` different first-PR repos overall.</li>
  <li>The single most common first-PR repo is used by only `3` hires overall.</li>
  <li>In the larger squads, the most common first-PR repo usually covers only about `18%` to `20%` of hires.</li>
</ul>

<DataTable data={context_prs_first_pr_repo_clustering}>
    <Column id=squad title="Squad" />
    <Column id=hires title="New Hires" fmt=num0 />
    <Column id=distinct_first_pr_repos title="Distinct First-PR Repos" fmt=num0 />
    <Column id=top_first_pr_repo title="Most Common First-PR Repo" />
    <Column id=top_first_pr_repo_hires title="Hires In That Repo" fmt=num0 />
    <Column id=top_first_pr_repo_share_pct title="Top Repo Share (%)" fmt=num1 />
    <Column id=top3_first_pr_repo_share_pct title="Top 3 Repo Share (%)" fmt=num1 />
</DataTable>

<p class="mini-caption">The main exception is `Echo`, where a small cohort clusters more tightly. Outside of those smaller pockets, this does not look like strong evidence of a single repeated onboarding PR pattern by squad.</p>

<DataTable data={context_prs_squad_repo_groups}>
    <Column id=squad title="Squad" />
    <Column id=repo_group title="Repo Group" />
    <Column id=prs title="PRs" fmt=num0 />
</DataTable>

<p class="mini-caption">This is an early proxy for the contribution environment each squad enters. It should help later when we settle the definition of `core repo` or `key repo` for integration metrics.</p>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/appendix">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Appendix →</span>
  </a>
</div>
