with base as (
    select days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and cohort_month >= '2025-03'
)
select
    round(median(days_to_first_pr), 1) as median_days,
    round(avg(days_to_first_pr), 1) as avg_days,
    round(quantile_cont(days_to_first_pr, 0.25), 1) as p25_days,
    round(quantile_cont(days_to_first_pr, 0.75), 1) as p75_days
from base
