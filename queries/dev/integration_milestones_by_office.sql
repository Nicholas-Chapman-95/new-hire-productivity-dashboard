with filtered as (
    select *
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and in_reliability_window = 1
      and role_productivity_category like '${inputs.role_focus.value}'
      and employee_type like '${inputs.employee_type.value}'
      and office like '${inputs.office.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
),
summary as (
    select
        office,
        count(*) as hires,
        median(days_to_first_pr) as first_pr_days,
        median(days_to_first_tier_3_pr) as core_repo_days,
        median(days_to_first_tier_3_pr) - median(days_to_first_pr) as integration_gap_days
    from filtered
    group by 1
    having count(*) >= 3
)
select
    office,
    hires,
    integration_gap_days,
    'First PR' as milestone,
    first_pr_days as days
from summary
union all
select
    office,
    hires,
    integration_gap_days,
    'Core Repo PR' as milestone,
    core_repo_days as days
from summary
order by integration_gap_days desc, office, milestone
