select
    os.wiser_id,
    os.employee_type,
    os.office,
    os.management_level,
    os.squad,
    os.role_productivity_category,
    os.is_true_onboarding_metric,
    os.in_reliability_window,
    ps.employee_pr_rank,
    ps.days_since_hire_at_merge
from fct_employee_onboarding_summary os
left join int_employee_pr_sequence ps
    on os.wiser_id = ps.wiser_id
where os.role_productivity_category in ('Software Engineering', 'Technical Adjacent')
order by os.employee_type, os.office, os.management_level, os.squad, ps.employee_pr_rank
