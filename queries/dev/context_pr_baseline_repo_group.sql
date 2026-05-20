select
    split_part(pr_repository_name, '-', 1) as repo_group,
    count(*) as prs,
    median(pr_cycle_time_days) as median_cycle_time_days,
    avg(pr_cycle_time_days) as avg_cycle_time_days,
    avg(case when pr_cycle_time_days <= 1 then 1.0 else 0.0 end) as pct_within_1_day
from productivity.pull_requests
where attributed_employee_job_family = 'Engineering'
    and attributed_employee_type = 'Permanent'
    and attributed_employee_wiser_id is not null
    and pr_merged_before_created = 0
group by 1
having count(*) >= 250
order by prs desc, repo_group
