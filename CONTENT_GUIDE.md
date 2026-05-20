# Content Guide

This guide is about meaning, not layout.

## Goal

Make claims precise, narrow, and decision-useful.

## Core-Section Standard

For core decision-facing sections, the default argument unit should fit this shape:

1. one answer-first sentence
2. up to three bullets
3. one supporting evidence block

If the argument cannot be made clearly in that space, it is usually not ready for the core page. Move the overflow into appendix or supporting detail.

## Argument Units

Use the compact argument unit as the building block for core pages.

- One page may contain multiple argument units when it is consolidating several distinct checks or recommendations.
- Each unit should still stand on its own:
  - one answer-first sentence
  - up to three bullets
  - one evidence block
- Do not use “multi-unit page” as a license for verbose sections. The compactness rule applies to each unit, not just to the page overall.
- If one unit starts absorbing second-order caveats, alternative framings, or exploratory visuals, move that overflow to appendix.

## Rules

- Lead with the answer. The first sentence should tell the reader the main problem, conclusion, or recommendation.
- State what the metric means, not what we wish it meant.
- If a page relies on an abstract construct such as `benchmark pace`, `peer pace`, `parity`, `contribution index`, or `quality-adjusted` output, define it in plain operational terms at first use.
- Do not hide the real comparison basis behind shorthand like `local slice` or `similar peers` unless the shorthand is immediately expanded into the actual fallback logic.
- When a page includes both a simple concrete read and a more abstract normalized read, prefer the simple read first unless the abstract construct is itself the decision rule.
- Prefer one clear claim over several partially-overlapping claims.
- Keep visible commentary short.
- Prefer bullets over paragraphs when the point is definitional, enumerative, or cautionary.
- Default to subtraction. If a page feels weak, first remove blocks before adding new framing, labels, or explanation.
- Do not narrate the page's own structure to the reader unless the sequence itself is the claim.
- Do not write copy that sounds like instructions to the author or the model instead of part of the story.
- Default to a collective analytical voice. Prefer `we`, `our`, and plain claims about what the evidence means over second-person instruction like `you should`, `you need to`, or `do not read this as` when `we should`, `we need to`, or `we should not read this as` would carry the same meaning more naturally.
- Write for scanning first: short paragraphs, short labels, and one point per block.
- Cut repeated explanation. If two sections make the same interpretive move, keep the stronger one.
- If one sentence can replace a paragraph, use the sentence.
- If one chart can carry several related summary lines, prefer that over multiple near-duplicate charts.
- Do not add commentary that merely names what the reader can already see from the title, axis, legend, or mark type.
- For core sections, prefer three bullets over three paragraphs.
- If a fourth bullet appears, stop and ask whether the page is mixing main argument with backup detail.
- If a page has more than one distinct claim, split it into separate compact units rather than stretching one oversized section.
- Every visible sentence must earn its place by doing at least one of these jobs:
  - define a term the reader cannot infer
  - state a non-obvious interpretation
  - state a meaningful limit or caveat
  - state an operational consequence
- If a sentence does none of those jobs, cut it or move it to appendix.
- For abstract metric terms, the first-use definition should usually answer three things in one sentence:
  - compared to whom
  - within what local slice or time basis
  - in what unit the comparison is made
- If the comparison basis uses fallback logic, name the fallback order directly when it matters to interpretation.
- Avoid compressed abstract phrases like `PR-observable reliability window` when a direct time-based description is clearer. Prefer plain wording such as `the period after PR tracking begins on 2025-03-01`.
- If a normalized or benchmarked metric is harder to parse than the raw series beneath it, introduce the raw series first and then use the normalized view as context or interpretation.
- If two views are alternate displays of the same argument, tabs are acceptable, but the key interpretation should stay visible outside the tab body unless it is genuinely tab-specific.
- Keep text density low enough that the chart-to-text rhythm stays visible while scrolling.
- If a statement is a caveat, uncertainty, or open definition, move it out of the main flow unless it is required to interpret the next chart.
- Avoid inflated phrasing like `proves`, `clearly shows`, or `demonstrates` unless the evidence really supports that strength.
- If a chart is mostly descriptive, say that directly.
- Distinguish:
  - absolute level
  - relative comparison
  - contribution to change
  - measurement caveat

## Information Placement

- Check not only whether a sentence is true, but whether this page is the right place for it in the dashboard.
- Landing and index pages should orient the reader and route them onward; they should not absorb metric definitions, taxonomy details, or decision rules that belong on destination pages.
- Keep definitions close to the page that actually uses them operationally. If a term is only needed to interpret `Ramp`, define it on `Ramp`, not on the section landing page.
- Keep recommendation logic on recommendation pages unless a shorter landing-page statement is required to prevent confusion.
- If a page starts summarizing several downstream pages in enough detail that the reader could skip them, move that detail down and keep only the orientation layer.
- When reviewing a page, ask two separate questions:
  - is this sentence clear?
  - is this sentence located at the right level of the dashboard?
- If the answer to the second question is no, move the sentence even if the wording itself is good.

## For Metric-Validity Pages

- Focus on construct meaning.
- Keep the interpretive claim in the main vertical flow; do not scatter it across multiple boxes or parallel sections.
- Replace process narration with the actual validity story. Say what is wrong with the metric or comparison, not that the reader is about to inspect a problem.
- Separate:
  - mistaken interpretation
  - better interpretation
  - operational consequence
- Do not let replacement-framework detail overwhelm the core interpretive point.
- Avoid headings or sentences like `read the three problems in order`, `this section sits between`, or `the page below shows`; convert them into plain claims about the evidence.

## Cognitive-Load Checklist

Pass/fail questions for rewritten pages:

- Is the page question and main claim visible before dense supporting detail starts?
- Can the reader get the answer from the first sentence?
- Can the main argument be restated as three bullets or fewer?
- If the page has several distinct claims, is each one contained in its own compact unit?
- Can a skim reader understand the takeaway in one scroll pass?
- Does each visible block do one job only?
- Is repeated explanation cut rather than restated in multiple sections?
- Is visible text density low enough that chart-to-text rhythm stays readable while scrolling?
- Are bullets used where prose would otherwise create a dense wall of text?
- Have visible controls been removed unless the reader genuinely needs them on the page?
- Have near-duplicate charts been consolidated where one view can do the job?
- Does every visible sentence survive the test: `if I delete this, does the reader lose meaning rather than comfort?`
- Are any captions just restating the chart title or the obvious function of the statistics?

## Red-Flag Copy

These phrases or structures should usually be deleted or rewritten:

- captions like `Each point is one hire.`
- captions like `One chart shows center and spread together.`
- captions like `Snapshot only: size, center, and upper tail...`
- obvious statistical glosses like `P25 and P75 show spread. Mean and Median show the center.`
- headings followed by filler sentences that only restate the heading
- commentary that explains the interface rather than the evidence
- essential reading notes hidden inside tabs even though the notes apply to the section as a whole
- core-page copy that really belongs in appendix
- second-person managerial instruction when the page is making a shared analytical recommendation, for example `you should check cohort mix first` instead of `we should check cohort mix first`

## Appendix Rule

Use appendix for:

- backup explanation after the main decision is already clear
- second-order caveats
- alternative formulations of the same point
- exploratory visuals that do not change the recommendation
- longer justification for a decision rule already stated on the core page

Core pages should keep only the minimum needed to make the recommendation credible.

## Homepage Failure Mode

The homepage was misjudged several times because structurally plausible copy kept passing source review even when the live page still felt like a basic route list or an overworked memo.

Rules:

- The homepage should work first as orientation: what this dashboard contains, what order to read it in, and which sections are primary versus reference.
- Keep homepage argument light. Do not restate the full metric verdict there if the destination pages already carry it.
- Homepage copy is optional. If the structure is visually obvious, prefer no intro sentence or paragraph.
- Do not narrate the dashboard's structure if the labels and card grouping already make it clear.
- Write for an analytically capable reader. Avoid housekeeping language like `the dashboard below`, `main flow`, `start here`, or `reference material` unless it removes real ambiguity.
- If the reader can infer the point from the visible information hierarchy, subtract prose instead of paraphrasing the layout.
- If plain markdown communicates the story cleanly, stop there.
- Treat additional homepage sections as suspect by default. Each extra block must earn its place.
- Do not let homepage copy explain both the verdict and the navigation in multiple different ways.
- If the homepage starts reading like a memo, move the substantive claim down into the relevant section page.
