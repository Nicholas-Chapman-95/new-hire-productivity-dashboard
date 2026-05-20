select
    wiser_id,
    hire_date,
    termination_date,
    first_report_date,
    first_report_month,
    latest_report_date,
    latest_report_month,
    employee_email,
    github_username,
    latest_team,
    latest_office,
    latest_tenure_months,
    latest_sub_team,
    latest_tribe,
    latest_squad,
    latest_management_level,
    latest_job_family,
    latest_job_family_group,
    role_productivity_category,
    is_engineering_role_latest,
    is_engineering_productivity_population,
    case
        when is_engineering_role_latest = 1 then 'Engineering'
        else 'Non-Engineering'
    end as employee_population_group,
    employee_type,
    is_active_latest,
    is_terminated,
    employment_status
from dim_employees
order by hire_date, wiser_id
