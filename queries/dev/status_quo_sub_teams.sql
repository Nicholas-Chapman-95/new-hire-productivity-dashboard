select
    sub_team as value,
    sub_team || ' (' || cast(count(*) as varchar) || ')' as label,
    count(*) as hires
from productivity.onboarding_summary
where is_true_onboarding_metric = true
  and in_reliability_window = 1
  and role_productivity_category like '${inputs.role_productivity_category.value}'
  and employee_type like '${inputs.employee_type.value}'
  and sub_team is not null
  and days_to_first_pr is not null
group by 1
order by hires desc, value
