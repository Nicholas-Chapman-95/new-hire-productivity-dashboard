with base as (
    select
        cohort_month,
        cast(cohort_month || '-01' as date) as cohort_date,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and cohort_month >= '2025-03'
)
select
    cohort_month,
    cohort_date,
    count(*) as hires,
    round(avg(days_to_first_pr), 1) as avg_days,
    round(median(days_to_first_pr), 1) as median_days,
    round(quantile_cont(days_to_first_pr, 0.25), 1) as p25_days,
    round(quantile_cont(days_to_first_pr, 0.75), 1) as p75_days,
    round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_30
from base
group by 1, 2
order by cohort_date
