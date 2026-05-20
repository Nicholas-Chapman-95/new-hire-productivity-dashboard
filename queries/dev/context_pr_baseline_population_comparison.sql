with new_hire_first_pr as (
    select
        'New-hire first PR' as population,
        pr_cycle_time_days
    from productivity.pull_requests p
    inner join productivity.onboarding_summary o
        on p.pr_id = o.first_pr_id
    where o.is_true_onboarding_metric = true
        and o.role_productivity_category = 'Software Engineering'
        and o.employee_type = 'Permanent'
        and p.pr_merged_before_created = 0
),
all_engineering_prs as (
    select
        'All engineering PRs' as population,
        pr_cycle_time_days
    from productivity.pull_requests
    where attributed_employee_job_family = 'Engineering'
        and attributed_employee_type = 'Permanent'
        and attributed_employee_wiser_id is not null
        and pr_merged_before_created = 0
),
tenured_engineering_prs as (
    select
        'Tenured engineering PRs' as population,
        pr.pr_cycle_time_days
    from productivity.pull_requests pr
    inner join productivity.dim_employees e
        on pr.attributed_employee_wiser_id = e.wiser_id
    where pr.attributed_employee_job_family = 'Engineering'
        and pr.attributed_employee_type = 'Permanent'
        and pr.attributed_employee_wiser_id is not null
        and pr.pr_merged_before_created = 0
        and e.is_active_latest = 1
        and date_diff('month', e.hire_date, pr.pr_merged_date) >= 6
),
combined as (
    select * from new_hire_first_pr
    union all
    select * from all_engineering_prs
    union all
    select * from tenured_engineering_prs
)
select
    population,
    count(*) as prs,
    median(pr_cycle_time_days) as median_cycle_time_days,
    avg(pr_cycle_time_days) as avg_cycle_time_days,
    avg(case when pr_cycle_time_days <= 1 then 1.0 else 0.0 end) as pct_within_1_day,
    avg(case when pr_cycle_time_days <= 3 then 1.0 else 0.0 end) as pct_within_3_days,
    avg(case when pr_cycle_time_days <= 7 then 1.0 else 0.0 end) as pct_within_7_days
from combined
group by 1
order by
    case population
        when 'New-hire first PR' then 1
        when 'Tenured engineering PRs' then 2
        when 'All engineering PRs' then 3
        else 4
    end
