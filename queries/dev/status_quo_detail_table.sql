select
    cast(hire_date as date) as hire_date,
    cohort_month,
    office,
    cast(management_level as integer) as management_level,
    team,
    sub_team,
    squad,
    job_family_group,
    job_family,
    days_to_first_pr,
    days_to_first_tier_3_pr,
    first_peer_velocity_match_ramp_month,
    first_90_day_median_cycle_time_days
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
order by hire_date desc, days_to_first_pr desc
