---
title: Metric Validity
sidebar_position: 2
queries:
  - metric_validity_naive_only_trend: dev/metric_validity_naive_only_trend.sql
  - metric_validity_pr_history_start: dev/metric_validity_pr_history_start.sql
  - metric_validity_raw_vs_valid_trend: dev/metric_validity_raw_vs_valid_trend.sql
  - metric_validity_level_mix: dev/metric_validity_level_mix.sql
  - metric_validity_office_mix: dev/metric_validity_office_mix.sql
  - metric_validity_squad_mix: dev/metric_validity_squad_mix.sql
  - metric_validity_job_family_group_mix: dev/metric_validity_job_family_group_mix.sql
  - metric_validity_job_family_mix: dev/metric_validity_job_family_mix.sql
  - metric_validity_timestamp_quality_summary: dev/metric_validity_timestamp_quality_summary.sql
  - metric_validity_timestamp_quality_issue_types: dev/metric_validity_timestamp_quality_issue_types.sql
---

<div class="page-flow page-flow--top">
  <a class="page-flow-link" href="/status-quo">
    <span class="page-flow-label">Prev page</span>
    <span class="page-flow-title">← Status Quo</span>
  </a>
</div>

<p><strong>Main point:</strong> we should use <code>Time to First PR</code> only as a narrow early-unblocking signal. Before treating it as evidence of onboarding quality, we should check historical PR coverage, cohort mix, interpretation limits, and timestamp validity.</p>

- Recover older PR history if possible. The current PR table starts on <code>2025-03-01</code>, while employee data starts on <code>2014-06-16</code>.
- We should clean or exclude impossible PR timestamp rows before using PR-based setup or ramp metrics.
- We should not read headline shifts as onboarding change until we check cohort mix, natural group differences, and sample size.
- We should use the metric for early setup only.

## Historical PR coverage gap

<p><strong>Main point:</strong> older cohorts are inflated by a fixable historical coverage gap.</p>

- We have employee data starting from <code>2014-06-16</code>, but merged PR data only starts from <code>2025-03-01</code>.
- We can only track new-hire productivity from <code>2025-03-01</code> onward.
- Restoring older PR history would improve benchmarking and let earlier cohorts be measured on the same basis as newer hires.

<p>The cutoff on <code>2025-03-01</code> creates an artificial improvement unless we exclude hires whose onboarding began before PR tracking starts.</p>

<Tabs id="metric-validity-history-gap" fullWidth=true background=true>
  <Tab label="Naive Trend">
    <LineChart
        data={metric_validity_naive_only_trend}
        x=cohort_date
        y=naive_days_to_first_observed_pr
        title="Naive values fall mechanically once PR history becomes observable"
        yFmt=num0
        yMin=0
        markers=true
        lineWidth=2
        color="#c46f4f"
        xAxisTitle=true
        yAxisTitle=true
    >
      <ReferenceLine
          data={metric_validity_pr_history_start}
          x=start_date
          label=event_label
          hideValue=true
          color="negative"
          lineType=dashed
          lineWidth=2
          labelPosition=aboveStart
      />
    </LineChart>
  </Tab>

  <Tab label="Filtered Comparison">
    <LineChart
        data={metric_validity_raw_vs_valid_trend}
        x=cohort_date
        y=days_to_first_pr
        series=series
        title="Including pre-window hires creates an artificial break in the trend"
        yFmt=num0
        yMin=0
        markers=true
        lineWidth=2
        seriesOrder={['Pre-window hires measured from PR tracking start', 'True onboarding cases in the PR-observable window']}
        seriesColors={{
          'Pre-window hires measured from PR tracking start': '#c46f4f',
          'True onboarding cases in the PR-observable window': '#1f5f8b'
        }}
        xAxisTitle=true
        yAxisTitle=true
    >
      <ReferenceLine
          data={metric_validity_pr_history_start}
          x=start_date
          label=event_label
          hideValue=true
          color="negative"
          lineType=dashed
          lineWidth=2
          labelPosition=aboveStart
      />
    </LineChart>
  </Tab>
</Tabs>

## Cohort mix and sample size

<p><strong>Main point:</strong> this is mainly an interpretation challenge. We should not read headline shifts as onboarding change until we check cohort mix, natural group differences, and sample size.</p>

- First-PR timing naturally differs across levels, offices, squads, and contribution environments.
- Teams that submit fewer PRs or onboard into slower-moving workflows can inflate the metric without implying worse onboarding.
- Small or granular cuts can move sharply from only a handful of hires, so use them as warnings rather than strong evidence.

<Dropdown name=validity_mix_cut defaultValue="level">
  <DropdownOption value="level" valueLabel="Level" />
  <DropdownOption value="office" valueLabel="Office" />
  <DropdownOption value="squad" valueLabel="Squad" />
  <DropdownOption value="job_family_group" valueLabel="Job Family Group" />
  <DropdownOption value="job_family" valueLabel="Job Family" />
</Dropdown>

{#if inputs.validity_mix_cut.value === 'level'}
<BarChart
    data={metric_validity_level_mix}
    x=level_label
    y=median_days_to_first_pr
    title="Level variation within valid onboarding cases"
    fillColor="#355c7d"
    sort=false
    yFmt=num0
    yMin=0
    xAxisTitle=true
    yAxisTitle=true
/>
{:else if inputs.validity_mix_cut.value === 'office'}
<BarChart
    data={metric_validity_office_mix}
    x=office_label
    y=median_days_to_first_pr
    title="Office variation within valid onboarding cases"
    fillColor="#c06c84"
    sort=false
    yFmt=num0
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>
{:else if inputs.validity_mix_cut.value === 'squad'}
<BarChart
    data={metric_validity_squad_mix}
    x=squad_label
    y=median_days_to_first_pr
    title="Squad variation within valid onboarding cases"
    fillColor="#2a9d8f"
    sort=false
    yFmt=num0
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>
{:else if inputs.validity_mix_cut.value === 'job_family_group'}
<BarChart
    data={metric_validity_job_family_group_mix}
    x=job_family_group_label
    y=median_days_to_first_pr
    title="Job family group variation and sample size"
    fillColor="#6c5b7b"
    sort=false
    yFmt=num0
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>
{:else}
<BarChart
    data={metric_validity_job_family_mix}
    x=job_family_label
    y=median_days_to_first_pr
    title="Job family variation and sample size"
    fillColor="#8d6a9f"
    sort=false
    yFmt=num0
    yMin=0
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>
{/if}

## Interpretation limits

<p><strong>Main point:</strong> we should use <code>Time to First PR</code> as an early unblocking signal, not as a headline measure of ramp quality or new-hire productivity.</p>

> **We should use it for:** how quickly a hire got unblocked enough to merge once.  
> **We should not use it for:** whether the hire is fully ramped, doing meaningful work, or contributing at a normal pace.

- A first merge is a narrow event, not a full productivity read.
- The metric is already sensitive to data coverage and cohort mix.
- If the metric worsens, we should inspect setup friction first: access, environment, review path, and early task design.

We should use later ramp and integration measures for the broader productivity question.

## Impossible PR timestamps

<p><strong>Main point:</strong> some PR rows have impossible timestamp orderings, so first-PR metrics need timestamp-quality checks before interpretation starts.</p>

- A PR cannot be created after it was already merged or closed.
- This is a data-validity issue, not an onboarding interpretation issue.
- Clean the source if possible. If not, explicitly exclude or guard against these rows before using PR timestamps in setup or ramp metrics.

<Grid cols=4>
  <BigValue data={metric_validity_timestamp_quality_summary} value=total_prs title="Total PRs" fmt=num0 />
  <BigValue data={metric_validity_timestamp_quality_summary} value=any_timestamp_issue title="PRs With Any Timestamp Issue" fmt=num0 />
  <BigValue data={metric_validity_timestamp_quality_summary} value=pct_with_any_timestamp_issue title="% With Any Timestamp Issue" fmt=pct1 />
  <BigValue data={metric_validity_timestamp_quality_summary} value=both_bad title="Created After Both" fmt=num0 />
</Grid>

<BarChart
    data={metric_validity_timestamp_quality_issue_types}
    x=issue_label
    y=prs
    sort=false
    title="Impossible PR timestamp patterns in the source table"
    fillColor="#c46f4f"
    yFmt=num0
    xLabelWrap=true
    showAllXAxisLabels=true
    xAxisTitle=true
    yAxisTitle=true
/>

<div class="page-flow page-flow--bottom">
  <a class="page-flow-link" href="/proposed">
    <span class="page-flow-label">Next page</span>
    <span class="page-flow-title">Proposed →</span>
  </a>
</div>
