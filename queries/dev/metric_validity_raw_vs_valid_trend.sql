with base as (
    select
        strptime(cohort_month || '-01', '%Y-%m-%d') as cohort_date,
        days_to_first_pr,
        is_true_onboarding_metric
    from productivity.onboarding_summary
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
),
raw_metric as (
    select
        cohort_date,
        'Pre-window hires measured from PR tracking start' as series,
        median(days_to_first_pr) as days_to_first_pr
    from base
    group by 1
),
valid_metric as (
    select
        cohort_date,
        'True onboarding cases in the PR-observable window' as series,
        median(days_to_first_pr) as days_to_first_pr
    from base
    where is_true_onboarding_metric = true
    group by 1
)
select *
from raw_metric

union all

select *
from valid_metric

order by cohort_date, series
