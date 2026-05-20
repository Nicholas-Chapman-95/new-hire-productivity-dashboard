select
    strptime(cohort_month || '-01', '%Y-%m-%d') as cohort_date,
    role_productivity_category,
    count(*) as hires
from productivity.onboarding_summary
where employee_type = 'Permanent'
group by 1, 2
order by 1, 2
