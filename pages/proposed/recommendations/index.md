---
title: Recommendations
sidebar_position: 5
queries: []
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/proposed/ramp/decomposition">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Ramp Drivers</span>
  </a>
</div>

Keep `time to first PR` as supporting setup context, use `% with first PR by day 30` as the main setup KPI, and use the local benchmark to judge how quickly hires catch up to normal peer pace after that first PR.

## What Leadership Should Track

Use two headline KPIs and keep `time to first PR` as supporting setup context rather than the company-wide onboarding headline.

- `Setup KPI`: `% with first PR by day 30`
- `Supporting setup context`: `time to first PR`
- `Ramp KPI`: `% at local benchmark by day 90`

### KPI 1: Setup / Initial Unblocking

- **Metric:** `% with first PR by day 30`
- **Primary page:** [Setup](/proposed/setup)
- **Leadership use:** catch whether new hires are getting access, context, and a realistic first path to contribution

### KPI 2: Ramp To Normal Pace

- **Metric:** `% at local benchmark by day 90`
- **Primary page:** [Ramp](/proposed/ramp)
- **Leadership use:** judge whether hires are catching up to the normal pace for their local environment by the likely end-of-probation check

### Supporting Watchpoints

- `% with first PR by day 60` when setup needs a second check
- `% at local benchmark by day 60` as an earlier ramp warning read
- `median days to local benchmark` as a pace summary alongside the `day 90` ramp KPI

## Business Actions

The current evidence points to a short list of concrete follow-ups rather than a broad company-wide intervention.

- `Setup`: the strongest current structural weakness is office-level, with `Singapore` materially behind `London` and `Tallinn` on `% with first PR by day 30`. We should review access, environment readiness, first-task design, and review-path friction there before treating the issue as a general productivity problem.
- `Ramp`: the current watchlist is concentrated in `Catalyst` squad, `L7`, and `Singapore` office. We should check whether those groups stay weak in both `30-59` and `60-89`, then review onboarding path, task difficulty, and review/support coverage for those specific groups.
- `Cross-office squads`: keep this as a secondary follow-up only. The current sample is still too office-skewed to justify it as a default management lens.
- `Data history`: recover older PR history if possible. The PR table currently starts on `2025-03-01`, which limits historical setup reads and weakens longer-run local-benchmark comparisons.
- `Data quality`: clean or exclude impossible PR timestamp rows before using PR-based setup or ramp metrics operationally.

## What Should Stay Diagnostic

Keep the following as supporting reads, not headline KPIs.

- `Spread and consistency`: use `P25`, `P50`, `P75`, and cohort size to tell whether movement is a slower center, a wider spread, or both
- `Cohort mix and segment shifts`: use them to stop leadership from misreading changing hiring allocation as onboarding deterioration

## Where To Look When A KPI Moves

Keep current watchpoints on the driver pages rather than on this policy page.

- Go to [Setup Drivers](/proposed/setup/decomposition) when `% with first PR by day 30` weakens.
- Go to [Ramp Drivers](/proposed/ramp/decomposition) when `% at local benchmark by day 90` weakens.
- Check cohort mix before treating an aggregate change as pure onboarding deterioration.

## What To Retire Or Narrow

Don't use the following as headline KPIs.

- a single global `time to first PR` score as the leadership headline
- first-PR cycle time on its own
- calendar `ramp_month 0`

Keep `days to first PR` only as a narrower setup diagnostic for spread and tail risk, not as the main company-wide onboarding score.

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/context">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Context →</span>
  </a>
</div>
