with filtered as (
    select *
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and in_reliability_window = 1
      and role_productivity_category like '${inputs.role_productivity_category.value}'
      and employee_type like '${inputs.employee_type.value}'
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and team like '${inputs.team.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
      and days_to_first_pr is not null
)
select
    median(days_to_first_pr) as median_days_to_first_pr,
    avg(days_to_first_pr) as average_days_to_first_pr,
    quantile_cont(days_to_first_pr, 0.25) as p25_days_to_first_pr,
    quantile_cont(days_to_first_pr, 0.75) as p75_days_to_first_pr
from filtered
