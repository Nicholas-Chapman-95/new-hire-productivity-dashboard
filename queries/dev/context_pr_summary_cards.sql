with totals as (
    select
        count(*) as total_prs,
        sum(case when pr_merged_before_created = 1 then 1 else 0 end) as invalid_cycle_prs
    from productivity.pull_requests
),
engineering as (
    select
        count(*) as engineering_prs,
        sum(case when pr_merged_before_created = 0 then 1 else 0 end) as valid_engineering_prs
    from productivity.pull_requests
    where attributed_employee_job_family = 'Engineering'
        and attributed_employee_type = 'Permanent'
        and attributed_employee_wiser_id is not null
),
new_hire as (
    select
        count(*) as new_hire_first_prs
    from productivity.onboarding_summary o
    inner join productivity.pull_requests p
        on o.first_pr_id = p.pr_id
    where o.is_true_onboarding_metric = true
        and o.role_productivity_category = 'Software Engineering'
        and o.employee_type = 'Permanent'
        and p.pr_merged_before_created = 0
)
select
    total_prs,
    engineering_prs,
    valid_engineering_prs,
    invalid_cycle_prs,
    new_hire_first_prs
from totals
cross join engineering
cross join new_hire
