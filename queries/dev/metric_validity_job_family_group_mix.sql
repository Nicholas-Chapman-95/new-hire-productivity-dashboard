with valid_cases as (
    select
        job_family_group,
        role_productivity_category,
        days_to_first_pr
    from productivity.onboarding_summary
    where employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and days_to_first_pr is not null
),
grouped as (
    select
        job_family_group,
        role_productivity_category,
        count(*) as hires,
        median(days_to_first_pr) as median_days_to_first_pr
    from valid_cases
    group by 1, 2
)
select
    job_family_group || ' | ' || role_productivity_category || ' (n=' || cast(hires as varchar) || ')' as job_family_group_label,
    job_family_group,
    role_productivity_category,
    hires,
    median_days_to_first_pr
from grouped
order by hires desc, job_family_group
