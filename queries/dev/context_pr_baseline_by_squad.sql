with new_hire_first_pr as (
    select
        'New-hire first PR' as population,
        o.squad,
        p.pr_cycle_time_days
    from productivity.onboarding_summary o
    inner join productivity.pull_requests p
        on o.first_pr_id = p.pr_id
    where o.is_true_onboarding_metric = true
        and o.role_productivity_category = 'Software Engineering'
        and o.employee_type = 'Permanent'
        and p.pr_merged_before_created = 0
),
tenured_engineering_prs as (
    select
        'Tenured engineering PRs' as population,
        pr.attributed_employee_squad as squad,
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
    select * from tenured_engineering_prs
)
select
    population,
    squad,
    count(*) as prs,
    median(pr_cycle_time_days) as median_cycle_time_days,
    avg(pr_cycle_time_days) as avg_cycle_time_days,
    avg(case when pr_cycle_time_days <= 1 then 1.0 else 0.0 end) as pct_within_1_day
from combined
group by 1, 2
order by squad, population
