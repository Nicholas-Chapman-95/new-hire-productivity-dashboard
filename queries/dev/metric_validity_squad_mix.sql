with valid_cases as (
    select
        squad,
        days_to_first_pr
    from productivity.onboarding_summary
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and days_to_first_pr is not null
),
grouped as (
    select
        squad,
        count(*) as hires,
        median(days_to_first_pr) as median_days_to_first_pr
    from valid_cases
    group by 1
)
select
    squad || ' (n=' || cast(hires as varchar) || ')' as squad_label,
    squad,
    hires,
    median_days_to_first_pr
from grouped
order by hires desc, squad
