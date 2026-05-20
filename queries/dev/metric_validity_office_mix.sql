with valid_cases as (
    select
        office,
        days_to_first_pr
    from productivity.onboarding_summary
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and days_to_first_pr is not null
),
grouped as (
    select
        office,
        count(*) as hires,
        median(days_to_first_pr) as median_days_to_first_pr
    from valid_cases
    group by 1
)
select
    office || ' (n=' || cast(hires as varchar) || ')' as office_label,
    office,
    hires,
    median_days_to_first_pr
from grouped
order by hires desc, office
