# Markdown / CSS Guide

This guide is about implementation.

## Goal

Keep the visual system simple and consistent.

## Default Layout

- Prefer plain markdown headings and paragraphs.
- For core decision sections, prefer one short paragraph or one bold answer line followed by a bullet list.
- On consolidated pages, repeat that compact section pattern instead of drifting into long transitional prose.
- Use `Grid` for structure, not decorative framing.
- Use `BigValue` only for true headline KPI strips.
- Use `Details` for secondary commentary, caveats, and long notes.
- Default to unboxed sections unless boxing materially improves comparison.
- For interpretive argument pages, default to a single-column reading path.
- Keep visible text blocks short enough to scan between charts without wall-of-text sections.
- Hide controls that are required for query defaults but not required for the reader's task.
- Use shared vertical-rhythm rules for helper text such as `eyebrow` and `mini-caption`; do not hand-tune spacing page by page.
- If the page title is already provided by the route layout, do not add a second visible `h1` inside the page body.
- On appendix consolidation pages, keep archived sub-pages hidden from sidebar navigation unless they are still part of the intended reading path.

## Vertical Rhythm

- Spacing should be defined by block role, not by individual page.
- Use three rhythm sizes only:
  - `tight`: labels to nearby explanatory text
  - `base`: ordinary block separation
  - `loose`: section boundaries and transitions into new evidence
- Helper text such as `mini-caption`, `eyebrow`, and short reading notes should use shared margins and shared max widths.
- Charts, KPI strips, lists, and `Details` blocks should each have a default amount of breathing room above and below.
- Prefer adjacency rules over one-off margins on page-specific classes.

Common adjacency cases that should be handled globally:

- helper text before a heading
- heading before a grid or chart
- chart before a caption
- KPI strip before a caption
- note block before a heading
- list before or after a chart
- `Details` after evidence sections

## Avoid

- Hero cards on normal analysis pages
- Decorative `story-card` or `priority-panel` wrappers unless there is a strong reason
- Mixing markdown lists inside raw HTML wrappers that will confuse the parser
- Side-by-side layouts that leave one column mostly empty
- Grid-heavy layouts that make the page read like a memo instead of a dashboard
- Side-by-side argument blocks when the reader needs a clear top-to-bottom sequence
- Duplicate title treatments that make the page header read twice
- More than one decorative pattern on a single page
- Multiple adjacent charts with separate captions when one combined series chart can carry the same message
- Visible dropdowns that add interface weight without adding a real reader decision
- Chart callouts that clip against the plot bounds, title area, or legend
- Section intros that only paraphrase the section heading
- Page-specific margin tweaks for common block transitions that should be handled by shared rhythm rules
- Multiple prose blocks before the first evidence block on a core decision page

## Raw HTML Rules

- If you open raw HTML like `<div>`, keep the block fully HTML until you close it.
- Inside raw HTML blocks, use `<p>`, `<ul>`, `<li>`, `<h2>`, etc.
- Do not mix markdown bullets inside `Group` or raw HTML blocks.

## Preferred Components

- `Grid cols=2` for direct comparisons
- `LineChart` for progression over time
- `BarChart` for ranked comparisons
- `DataTable` for exact values
- `Details` for caveats
- Markdown blockquotes or documented shared HTML/CSS patterns for one important interpretive contrast

## Component Guardrails

- Do not introduce undocumented Evidence tags on prose pages without a verified local example.
- Treat chart-only or context-dependent components as unsafe by default on narrative pages.
- If you need emphasis on a prose page, prefer markdown, `Details`, or a documented shared HTML/CSS pattern over an unverified component tag.
- If a component choice changes the rendered structure, include browser QA in the rewrite loop before asking for narrative signoff.
- If callouts or annotations are used, verify in-browser that they do not clip, collide, or dominate the chart more than the data itself.
- When spacing feels wrong, fix the shared rhythm rule first. Only add page-specific spacing if the page truly has a unique structural need.

## Styling Principle

If a page works without a custom class, prefer not to add one.

## Homepage / Landing Pages

- The homepage must read as a compact orientation page, not a flat site index and not a miniature argument memo.
- Put structure and reading order above heavy interpretation. Links should clarify the route through the story.
- Homepage prose is optional. If the route is already clear from titles, labels, and grouping, prefer no intro copy.
- Do not add text that simply paraphrases the visible card layout.
- Start with plain markdown. Only move to shared dashboard section wrappers if the markdown version is clearly insufficient in the browser.
- Use the shared dashboard section patterns on landing pages only after the live render proves they improve the page. Do not invent one-off wrapper classes unless the shared stylesheet is updated in the same task and browser QA confirms the render.
- Do not sign off a homepage rewrite from source alone if the live page still looks visually flat, effectively unstyled, or route-map-like.
- If a wrapper class appears in page markup but has no verified definition in `app.css`, treat the page as unstyled and the task as failed.
- Do not solve a weak homepage primarily with more CSS. Fix content density and structure first.
- Separate primary routes from reference routes visually before adding more prose.
