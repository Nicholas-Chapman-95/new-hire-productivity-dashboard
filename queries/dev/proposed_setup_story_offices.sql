with base as (
    select
        office,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and cohort_month >= '2025-03'
)
select
    office,
    count(*) as hires,
    round(avg(days_to_first_pr), 1) as avg_days,
    round(median(days_to_first_pr), 1) as median_days,
    round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_30
from base
group by 1
order by hires desc
