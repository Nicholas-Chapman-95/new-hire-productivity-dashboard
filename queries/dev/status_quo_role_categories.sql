select
    role_productivity_category as value,
    role_productivity_category || ' (' || cast(count(*) as varchar) || ')' as label,
    count(*) as hires
from productivity.onboarding_summary
where role_productivity_category in ('Software Engineering', 'Technical Adjacent')
  and in_reliability_window = 1
  and employee_type like '${inputs.employee_type.value}'
  and days_to_first_pr is not null
group by 1
order by hires desc, value
