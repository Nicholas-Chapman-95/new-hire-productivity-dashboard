select *
from (
    values
        (
            'Consistency lens',
            'If the setup median looks acceptable but the spread stays wide, perhaps predictability itself should be a headline onboarding metric.',
            'Setup percentile bands, IQR by group, and monthly cohort spread.',
            'Useful diagnostic, but it explains setup and ramp rather than replacing them.',
            'Rolled into setup and ramp interpretation instead of kept as a standalone headline metric.',
            1
        ),
        (
            'Integration proxy',
            'If first PRs are too shallow, a repo-based central-work milestone might better reflect meaningful onboarding progress.',
            'Days to first PR versus first tier-3 or squad-core repo PR, especially by office and squad.',
            'Directionally interesting gaps exist, but the current core-repo definition is too loose to support a KPI.',
            'Rejected on measurement quality grounds rather than because the idea is unimportant.',
            2
        ),
        (
            'Early-friction cycle time',
            'If first PRs take much longer to merge than normal PRs, review friction might explain slow onboarding.',
            'First 90-day cycle-time fields and first-PR merge timing checks.',
            'Signal was weak, and timestamp-quality issues limit interpretation confidence.',
            'Set aside because the data quality and explanatory power were both weaker than setup completion metrics.',
            3
        ),
        (
            'Time-to-X PR milestones',
            'If first PR is too shallow but peer-normalized ramp is too complex, time to 5th or 10th PR might be a better bridge metric.',
            'Days to 5th PR, days to 10th PR, and days from first to 10th PR.',
            'Useful supporting milestones that capture sustained contribution.',
            'Kept as support, not promoted to a separate headline page because the overlap with ramp is high.',
            4
        ),
        (
            'Calendar ramp_month 0',
            'If early calendar-month peer velocity is used as the first ramp read, it may show progress faster.',
            'Calendar-month velocity curves versus exact 30-day window curves.',
            'Late-month hires were structurally penalized, making the apparent signal unreliable.',
            'Replaced by exact rolling 30-day windows.',
            5
        ),
        (
            'Cadence and team context',
            'Maybe nearby hires, larger local teams, or same-squad cohorts make onboarding easier.',
            'Office and squad hire cadence, current squad size, and same-squad other-hires-within-30-days checks.',
            'Office cadence was weak and inconsistent. Larger squad footprint was essentially neutral. Same-squad timing effects were non-monotonic.',
            'Not stable enough to support a confident management finding.',
            6
        ),
        (
            'Employee-type comparisons',
            'Maybe onboarding should be compared across permanent, intern, contractor, and fixed-term cohorts.',
            'Employee-type slices inside the productivity and onboarding summary models.',
            'The groups behave differently, but they are not comparable enough for one aggregate onboarding score.',
            'Useful for scope control and exclusions, not as a unified KPI.',
            7
        )
) as t (idea, hypothesis, evidence_used, finding, why_not_advanced, sort_order)
order by sort_order
