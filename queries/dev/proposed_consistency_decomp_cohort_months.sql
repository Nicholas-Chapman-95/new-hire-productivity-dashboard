select
    cohort_month as value,
    cohort_month || ' (' || cast(count(*) as varchar) || ')' as label,
    count(*) as hires
from productivity.onboarding_summary
where is_true_onboarding_metric = true
  and role_productivity_category = 'Software Engineering'
  and employee_type = 'Permanent'
  and days_to_first_pr is not null
  and office like '${inputs.office.value}'
  and squad like '${inputs.squad.value}'
  and sub_team like '${inputs.sub_team.value}'
  and cast(management_level as varchar) like '${inputs.management_level.value}'
group by 1
order by value
