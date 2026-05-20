with filtered as (
    select *
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and in_reliability_window = 1
      and role_productivity_category like '${inputs.role_focus.value}'
      and employee_type like '${inputs.employee_type.value}'
      and squad like '${inputs.squad.value}'
),
summary as (
    select
        squad,
        count(*) as hires,
        median(days_to_first_pr) as first_pr_days,
        median(days_to_first_tier_3_pr) as core_repo_days,
        median(days_to_first_tier_3_pr) - median(days_to_first_pr) as integration_gap_days
    from filtered
    group by 1
    having count(*) >= 3
)
select squad, hires, integration_gap_days, 'First PR' as milestone, first_pr_days as days
from summary
union all
select squad, hires, integration_gap_days, 'Core Repo PR' as milestone, core_repo_days as days
from summary
order by integration_gap_days desc, squad, milestone
