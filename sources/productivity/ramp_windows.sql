select
    rw.employee_type,
    os.office,
    os.management_level,
    os.role_productivity_category,
    substr(os.cohort_month, 1, 4) as cohort_year,
    rw.squad,
    rw.ramp_month,
    rw.pct_of_selected_peer_median_velocity
from fct_employee_ramp_windows rw
left join fct_employee_onboarding_summary os
    on rw.wiser_id = os.wiser_id
where os.role_productivity_category in ('Software Engineering', 'Technical Adjacent')
  and ramp_month between 0 and 5
order by rw.employee_type, os.office, os.management_level, rw.squad, rw.ramp_month
