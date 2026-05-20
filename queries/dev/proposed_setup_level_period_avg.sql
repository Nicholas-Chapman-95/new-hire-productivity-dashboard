with base as (
    select
        'L' || cast(cast(management_level as integer) as varchar) as level,
        cast(management_level as integer) as level_sort,
        case
            when cohort_month between '2025-03' and '2025-08' then '2025-03 to 2025-08'
            when cohort_month between '2025-09' and '2026-02' then '2025-09 to 2026-02'
        end as period,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and management_level is not null
      and cohort_month between '2025-03' and '2026-02'
)
select
    level,
    level_sort,
    period,
    count(*) as hires,
    round(avg(days_to_first_pr), 1) as mean_days_to_first_pr
from base
group by 1, 2, 3
order by level_sort, period
