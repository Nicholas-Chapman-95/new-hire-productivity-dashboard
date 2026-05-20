# Story Guide

This guide is about sequence and emphasis.

## Goal

Make the page readable in one pass without requiring explanatory scaffolding.

## Default Story Order

1. answer first: main claim and recommendation
2. up to three bullets that support the answer
3. primary evidence or comparison
4. implication or decision rule
5. supporting detail or appendix link
6. caveats or open questions in collapsed form

## Argument Units

Treat the sequence above as the default unit of argument.

- A short core page may contain one argument unit.
- A consolidated page may contain several argument units in sequence.
- Each unit should introduce one distinct claim only.
- When a page contains multiple units, the transition between them should be explicit and light. Do not let the page drift into memo-style prose between units.

## Rules

- One page should have one dominant narrative path.
- Do not put several equal-weight sections before the reader has the thesis.
- If a page needs long “how to read this” instructions, the structure is probably wrong.
- If a summary page keeps missing the mark, simplify the story order before redesigning the layout.
- Do not use meta-copy that explains where the page sits in the site or how the reader should move through the page unless that sequence is itself the substantive point.
- Put the first useful comparison above secondary framing.
- Prefer progression over taxonomy.
- Prefer a clean top-to-bottom reading path on interpretive pages.
- Prefer one strong evidence block over two weaker blocks that make the same point.
- Do not put a heading on the page unless the block under it says something the heading itself does not already say.
- For core decision pages, treat one sentence + three bullets + one evidence block as the default unit of argument.
- If a page needs several claims, stack several compact units instead of expanding one oversized section.
- Keep section count and transitions light enough that the page can be read in one scroll pass.
- If the argument depends on sequence, do not split it into side-by-side blocks.
- Tabs can reduce visual clutter for alternate evidence views, but they should not hide the main narrative. Shared takeaway text should sit above or below the tabs so the reader does not need to open every tab to understand the section.
- On appendix decision-log pages, default to a single linear sequence of investigated ideas. Do not make the reader compare parallel sections to understand what was tested.
- If the layout already renders the page title, do not repeat a second visible `h1` inside the page body.

## For Interpretation / Validity Pages

Recommended order:
1. one-sentence answer: what is wrong and what to do about it
2. up to three bullets
3. direct evidence
4. operational consequence
5. open definitions or cautions

Additional rules:
- Default to a single-column flow.
- Use a short callout when a contrast needs emphasis; do not repeat the same comparison in multiple grids.
- Side-by-side layout is the wrong choice when it turns the page into a memo, forces back-and-forth eye movement, or makes both columns compete as primary.
- If a page feels cognitively heavy, remove parallel sections before removing evidence.
- Replace authorial scaffolding with story sentences.
  Bad: `Read the three problems in order.`
  Better: `Three things can make the metric mislead us: missing PR history, unstable cohort mix, and over-broad interpretation.`
  Bad: `This section sits between the top-line view and the deeper validity checks.`
  Better: `The top-line trend is only credible after we remove invalid cases, account for unstable comparisons, and keep the interpretation narrow.`

One-scroll-pass checklist:
- Is the thesis visible before the page branches into support?
- Does the first sentence already give the answer?
- Could the visible argument fit on an index card: one sentence, three bullets, one chart?
- If there are multiple claims on the page, does each one still fit that index-card test?
- Are there no more than one to two visible interpretive moves before the first evidence block?
- Does the page keep one dominant top-to-bottom reading path?
- If a side-by-side block exists, is it helping direct comparison instead of splitting the narrative?
- Could one chart replace multiple adjacent charts without losing the point?
- If tabs are used, can the reader still understand the section without opening every tab?
- Are section transitions short enough that the page still feels like one pass rather than several stacked memos?

## Rewrite Evaluation Loop

Use this loop for interpretation pages after any substantial rewrite:

1. writer edits the page
2. run `build:strict`
3. run browser QA on the rewritten page plus one adjacent summary or parent page
4. evaluate the rendered result against the one-scroll-pass checklist
5. explicitly check for:
   - visible control clutter
   - repeated caveats
   - stacked charts that could be consolidated
   - dense prose that should become bullets
   - headings followed by filler sentences
   - captions that only restate the visible chart structure
   - commentary that an analytics manager would consider obvious
   - material that belongs in appendix rather than the core page
6. revise until the page passes

## Review Standard

Do not sign off a rewrite from source review alone when the problem being solved is cognitive load, visual clutter, or page rhythm.

For those tasks, browser review must answer:

1. Which sentences on the page are doing real analytical work?
2. Which sentences are only reducing author anxiety?
3. Which captions could be deleted with no loss of meaning?
4. Which annotations or callouts are colliding with chart bounds, titles, or legends?

## Homepage Rule

For the homepage or any landing-style summary page:

1. orientation to the dashboard or section
2. optional one-sentence framing only if the visible structure is otherwise ambiguous
3. simple navigation to the primary next pages
4. secondary or reference routes separated clearly from the main path

Keep substantive argument on the destination pages unless the homepage genuinely needs a short framing sentence to avoid confusion.

If headings, labels, and grouping already explain the route, do not add prose that merely restates the layout.

Do not expand beyond that unless the plain version fails for a specific reason observed in the browser.

## For Analysis Pages

Recommended order:
1. top-line read
2. trend or progression
3. decomposition
4. deeper context
5. supporting tables
