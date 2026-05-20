select
    office as value,
    office || ' (' || cast(count(*) as varchar) || ')' as label,
    count(*) as hires
from productivity.onboarding_summary
where is_true_onboarding_metric = true
  and role_productivity_category = 'Software Engineering'
  and employee_type = 'Permanent'
  and office is not null
  and days_to_first_pr is not null
group by 1
order by hires desc, value
