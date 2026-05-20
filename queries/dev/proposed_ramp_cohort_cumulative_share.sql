with mature_cohorts as (
    select
        os.cohort_month,
        count(distinct os.wiser_id) as hires
    from productivity.onboarding_summary os
    join productivity.exact_ramp_windows erw
        on os.wiser_id = erw.wiser_id
    where os.role_productivity_category = 'Software Engineering'
      and os.employee_type = 'Permanent'
      and os.is_true_onboarding_metric = true
      and os.in_reliability_window = 1
      and erw.day_window = 5
      and erw.is_window_fully_observed = 1
    group by 1
    having count(distinct os.wiser_id) >= 4
),
cohort_window as (
    select
        os.cohort_month,
        mc.hires,
        erw.day_window,
        erw.day_window_label,
        sum(erw.pr_count) as cohort_prs
    from productivity.onboarding_summary os
    join mature_cohorts mc
        on os.cohort_month = mc.cohort_month
    join productivity.exact_ramp_windows erw
        on os.wiser_id = erw.wiser_id
    where os.role_productivity_category = 'Software Engineering'
      and os.employee_type = 'Permanent'
      and os.is_true_onboarding_metric = true
      and os.in_reliability_window = 1
      and erw.is_window_fully_observed = 1
    group by 1, 2, 3, 4
),
ranked as (
    select
        *,
        sum(cohort_prs) over (
            partition by cohort_month
            order by day_window
            rows between unbounded preceding and current row
        ) as cumulative_prs,
        sum(cohort_prs) over (partition by cohort_month) as total_prs_180d
    from cohort_window
)
select
    cohort_month,
    hires,
    day_window,
    day_window_label,
    cohort_prs,
    cumulative_prs,
    round(cumulative_prs::double / nullif(total_prs_180d, 0), 4) as cumulative_share_of_180d_prs
from ranked
order by cohort_month, day_window
