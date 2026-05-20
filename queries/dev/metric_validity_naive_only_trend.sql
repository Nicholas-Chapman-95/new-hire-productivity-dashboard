with base as (
    select
        strptime(cohort_month || '-01', '%Y-%m-%d') as cohort_date,
        date_diff('day', hire_date, first_pr_merged_at) as naive_days_to_first_observed_pr
    from productivity.onboarding_summary
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and hire_date is not null
      and first_pr_merged_at is not null
)
select
    cohort_date,
    median(naive_days_to_first_observed_pr) as naive_days_to_first_observed_pr
from base
group by 1
order by cohort_date
