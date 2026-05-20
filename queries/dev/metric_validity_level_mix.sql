with valid_cases as (
    select
        cast(management_level as integer) as level_order,
        days_to_first_pr
    from productivity.onboarding_summary
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and days_to_first_pr is not null
)
select
    'L' || cast(level_order as varchar) as level_label,
    level_order,
    median(days_to_first_pr) as median_days_to_first_pr,
    quantile_cont(days_to_first_pr, 0.25) as p25_days_to_first_pr,
    quantile_cont(days_to_first_pr, 0.75) as p75_days_to_first_pr,
    count(*) as hires
from valid_cases
group by 1, 2
order by level_order
