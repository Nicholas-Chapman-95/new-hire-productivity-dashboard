# Dashboard Rebuild Reference

This file is the working design reference for the separate Evidence rebuild app in `05_dashboard/evidence`.

It is not a generic skill yet. It is a project-specific reference so we can keep the design rules, component patterns, and preferred visual structures in one place while rebuilding the dashboard.

## External References

Primary visual references:

- Happiness dashboard deployed app: `https://vidit.evidence.app/happiness/`
- SF311 starter deployed app: `https://sf311.evidence.app/`
- SF311 starter repo branch: `https://github.com/evidence-dev/sf311_starter/tree/section-6`

## What We Like From These Examples

### From the happiness dashboard

- Short page intros instead of long argument blocks.
- A chart-first layout.
- Small number of strong sections per page.
- Simple hierarchy: title, chart title, chart, then supporting context.
- KPI or ranked-summary blocks used sparingly rather than filling the whole page with cards.

### From the SF311 app

- Supporting context can be collapsed under `About this data` instead of crowding the main narrative.
- Nested explanatory sections work well for definitions and caveats.
- The page stays focused on the data first and the methodology second.

## Rebuild Design Rules

- Build pages as standalone decision surfaces, not long essays.
- Keep the top of the page visually quiet.
- Put filters close to the chart they control.
- Use one primary visual per section.
- Put caveats, scope rules, and definitions in collapsible sections unless they are essential to interpretation.
- Default to median or completion-rate summaries over means when the distribution is skewed.
- Avoid large hero copy unless a page really needs a thesis statement.
- Prefer 2 to 4 sections per page, not 7 to 8 small blocks.

## Page Template We Are Using

Recommended structure:

1. page title
2. short subtitle
3. compact filter bar
4. primary chart block
5. optional supporting chart block
6. nested `About this data` section

## Evidence Component Patterns

### Compact filter bar

```md
<div class="rebuild-filterbar">
<div class="rebuild-filter">
<p class="rebuild-filter-label">Office</p>
<Dropdown data={offices} name=office value=office>
    <DropdownOption value="%" valueLabel="All Offices"/>
</Dropdown>
</div>
</div>
```

### Primary chart block

```md
<div class="rebuild-chart-block">
<div class="rebuild-block-header">
<p class="rebuild-block-kicker">First Cut</p>
<h2>Each point is one new hire</h2>
<p>Hire date on the x-axis. Days to first merged PR on the y-axis.</p>
</div>

<ScatterPlot
    data={status_quo_first_pr_scatter}
    x=hire_date
    y=days_to_first_pr
    title="Time to First PR by Hire Date"
    yFmt=num0
/>
</div>
```

### Nested `About this data`

```md
<Details title="About this data">
<p>Short summary of scope and caveats.</p>

<Details title="Why start with this metric?">
<p>Explain why the metric is still useful even if it is incomplete.</p>
</Details>
</Details>
```

## Graph Patterns We Want Available

### Status Quo

- Raw scatter of hire date vs days to first PR
- Monthly median trend
- Possible follow-up: completion-rate line for `<= 30 days` and `<= 60 days`

### Context

- PR volume over time
- team-to-repo relationship view
- baseline team velocity comparison
- contribution concentration view

### Framework / Later Pages

- onboarding completion-rate trends
- integration gap comparisons
- ramp curves against peer baselines
- friction diagnostics as supporting charts rather than headline charts

## Current Decisions

- Separate rebuild app lives in `05_dashboard/evidence`
- Current page order:
  - `Home`
  - `Status Quo`
  - `Context`
- We are using the `Status Quo` page as the first design proving ground

## Operational Lessons

- Always verify which repo and process are actually serving `localhost` before editing against a live URL.
- For this project, `evidence.config.yaml` theme settings are fine; the dangerous part was replacing base CSS instead of extending it.
- Keep `app.css` additive. Preserve Evidence/Tailwind base styles and layer project rules after them.
- Preview/build scripts must not copy markdown routes twice or overwrite template `src/app.css` wholesale.
- If the site shows raw HTML or a huge unstyled Evidence logo, treat that as a CSS/runtime delivery failure before assuming the page markdown is broken.

## Current Checkpoint

Saved state for the next working session:

- We intentionally reverted `Status Quo` back toward a stock Evidence feel after custom layout and custom slider experiments became too costly.
- The page currently uses stock Evidence controls for:
  - `Office`
  - `Level`
  - `Squad`
  - `Team`
  - `Colour By`
- `Colour By` is conceptually a display selector, not a filter, but it is still implemented with a normal stock dropdown.
- The scatter chart supports coloring by:
  - `Level`
  - `Office`
  - `Squad`
  - `Team`
  - `Sub-Team`
  - `Job Family Group`
  - `Job Family`
- Level colors were changed from unrelated category colors to a low-to-high ordered palette.
- The monthly summary section now supports:
  - `Median`
  - `Average`
  - `P25 and P75`
  - `Show All`
- `Show All` is now one combined stock line chart backed by a dedicated query rather than inline page logic.
- We explicitly decided not to build a custom shaded `P25–P75` ribbon yet.
- We also decided to avoid custom controls for now and stay close to stock Evidence unless a later need justifies custom work.

## Next Likely Tasks

- Review whether `Status Quo` should keep all four filters (`Office`, `Level`, `Squad`, `Team`) or simplify.
- Build the `Context` page next.
- Keep CSS changes light and avoid reintroducing custom interaction components unless necessary.
