with cohort_window as (
    select
        os.cohort_month,
        count(distinct os.wiser_id) as hires,
        erw.day_window,
        sum(erw.pr_count) as cohort_prs
    from productivity.onboarding_summary os
    join productivity.exact_ramp_windows erw
        on os.wiser_id = erw.wiser_id
    where os.role_productivity_category = 'Software Engineering'
      and os.employee_type = 'Permanent'
      and os.is_true_onboarding_metric = true
      and os.in_reliability_window = 1
      and erw.is_window_fully_observed = 1
    group by 1, 3
    having count(distinct os.wiser_id) >= 4
),
ranked as (
    select
        *,
        sum(cohort_prs) over (
            partition by cohort_month
            order by day_window
            rows between unbounded preceding and current row
        ) as cumulative_cohort_prs
    from cohort_window
)
select cohort_month, hires, 'By day 30' as series, cumulative_cohort_prs as value
from ranked
where day_window = 0
union all
select cohort_month, hires, 'By day 60' as series, cumulative_cohort_prs as value
from ranked
where day_window = 1
union all
select cohort_month, hires, 'By day 90' as series, cumulative_cohort_prs as value
from ranked
where day_window = 2
union all
select cohort_month, hires, 'By day 120' as series, cumulative_cohort_prs as value
from ranked
where day_window = 3
order by cohort_month, series
