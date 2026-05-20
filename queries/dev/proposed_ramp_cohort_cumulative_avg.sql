with cohort_window as (
    select
        os.cohort_month,
        erw.day_window,
        erw.day_window_label,
        count(distinct os.wiser_id) as hires,
        round(avg(erw.pr_count), 1) as avg_prs_per_hire
    from productivity.onboarding_summary os
    join productivity.exact_ramp_windows erw
        on os.wiser_id = erw.wiser_id
    where os.role_productivity_category = 'Software Engineering'
      and os.employee_type = 'Permanent'
      and os.is_true_onboarding_metric = true
      and os.in_reliability_window = 1
      and erw.is_window_fully_observed = 1
    group by 1, 2, 3
    having count(distinct os.wiser_id) >= 4
),
ranked as (
    select
        *,
        sum(avg_prs_per_hire) over (
            partition by cohort_month
            order by day_window
            rows between unbounded preceding and current row
        ) as cumulative_avg_prs_per_hire
    from cohort_window
)
select
    cohort_month,
    hires,
    day_window,
    day_window_label,
    avg_prs_per_hire,
    round(cumulative_avg_prs_per_hire, 1) as cumulative_avg_prs_per_hire
from ranked
where cohort_month >= '2025-04'
order by cohort_month, day_window
