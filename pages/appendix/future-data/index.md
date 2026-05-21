---
title: Additional Data We'd Want
sidebar_position: 2
queries: []
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/appendix">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Appendix</span>
  </a>
</div>

<p class="eyebrow page-eyebrow">Appendix</p>

The current setup and ramp read is useful, but several better explanatory cuts remain unavailable because the data model stops at hires, org context, repos, and PR events.

- The highest-value additions are data that would distinguish `slow because the work is harder` from `slow because onboarding support is weaker`.
- Most of these would improve interpretation more than they would create a new headline KPI.
- We should prefer additions that can be linked cleanly to the hire, team, and time window already used in the dashboard.

<div class="priority-panel">
  <h2>If We Could Add Only A Few Things</h2>
  <p>The strongest next data additions are: clearer team work context, PR review-friction data, PTO / availability context, then incident load.</p>
</div>

## Highest-Value Follow-Up Data

<div class="feature-panel">
  <h2>1. Team work context and clearer `core work` definitions</h2>
  <p>The current repo-based `central work` idea is directionally useful, but we still do not know enough about what each squad actually owns or which work types matter most.</p>
  <p><strong>What we'd want:</strong> a defensible map of squad-owned repos, services, domains, and the difference between peripheral maintenance work and truly central contribution.</p>
  <p><strong>What it would answer:</strong> whether new hires are reaching meaningful team work, not just any PR milestone.</p>
  <p><strong>Why it matters:</strong> it would separate `fast first PR` from `fast entry into core squad work`, which is probably the more valuable management question.</p>
</div>

<div class="feature-panel">
  <h2>2. PR review friction and back-and-forth correction loops</h2>
  <p>We can see merged PR timing today, but we do not yet see how much correction, rework, or review churn sits inside that path.</p>
  <p><strong>What we'd want:</strong> review comments, change-request events, review rounds, reopen cycles, and time between feedback and the next revision.</p>
  <p><strong>What it would answer:</strong> whether a slower path reflects missing reviewer attention or repeated correction inside the review loop.</p>
  <p><strong>Why it matters:</strong> for onboarding, heavy back-and-forth may be a better signal of missing context, unclear standards, or weak task matching than raw cycle time alone.</p>
</div>

<div class="feature-panel">
  <h2>3. Incidents and operational interruption load</h2>
  <p>Some teams may onboard into a noisier operating environment than others, but the current dashboard cannot see interruption burden.</p>
  <p><strong>What we'd want:</strong> incident count, paging load, severity mix, and time spent in incident response.</p>
  <p><strong>What it would answer:</strong> whether weaker setup or ramp in some groups is really onboarding weakness or just higher operational interruption.</p>
  <p><strong>Why it matters:</strong> without it, we risk reading lower output as onboarding weakness when the real issue is support capacity or production noise.</p>
</div>

<div class="feature-panel">
  <h2>4. PTO, leave, and local availability constraints</h2>
  <p>The business-day prototype improved timing measurement, but it still cannot account for the real people-availability effects that matter most to onboarding.</p>
  <p><strong>What we'd want:</strong> hire PTO, manager PTO, reviewer PTO, team leave overlap, and local shutdown periods.</p>
  <p><strong>What it would answer:</strong> whether a slower onboarding path reflects the hire's own availability, or the absence of the people who are supposed to unblock, review, and mentor them.</p>
  <p><strong>Why it matters:</strong> this would likely explain some of the residual variation that public-holiday adjustment alone could not remove.</p>
</div>

## Other Useful Additions

<div class="feature-panel">
  <h2>Other Additions Worth Considering</h2>
  <ul>
    <li><code>Environment and access readiness</code>: account creation, repo access, permissions, local setup completion, and time to first runnable environment.</li>
    <li><code>Task difficulty or task type</code>: whether the first tasks were docs, config, bug fixes, production code, or larger feature work.</li>
    <li><code>Review latency and reviewer assignment</code>: who reviewed the PR, how long first review took, and whether the hire had a stable reviewer or mentor path.</li>
    <li><code>Onboarding plan completion</code>: whether expected setup steps, training modules, shadowing, or buddy milestones actually happened.</li>
    <li><code>Manager / mentor support structure</code>: whether the hire had a named buddy, onboarding owner, or stable technical sponsor.</li>
  </ul>
</div>

<div class="priority-panel">
  <h2>Why These Matter More Than More Slicing</h2>
  <p>The dashboard already slices by <code>office</code>, <code>level</code>, <code>sub-team</code>, and <code>squad</code>. The main remaining weakness is not lack of segmentation. It is lack of explanatory context about work shape, support burden, and availability constraints.</p>
</div>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/appendix/ideas-tested">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Ideas Tested and Set Aside →</span>
  </a>
</div>
