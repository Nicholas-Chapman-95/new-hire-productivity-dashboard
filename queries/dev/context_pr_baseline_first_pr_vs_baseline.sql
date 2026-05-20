with repo_baselines as (
    select
        pr_repository,
        pr_repository_area,
        median(pr_cycle_time_days) as repo_median_cycle_time_days
    from productivity.pull_requests
    where attributed_employee_job_family = 'Engineering'
        and attributed_employee_type = 'Permanent'
        and attributed_employee_wiser_id is not null
        and pr_merged_before_created = 0
    group by 1, 2
),
area_baselines as (
    select
        attributed_employee_squad as squad,
        pr_repository_area,
        median(pr_cycle_time_days) as squad_area_median_cycle_time_days
    from productivity.pull_requests
    where attributed_employee_job_family = 'Engineering'
        and attributed_employee_type = 'Permanent'
        and attributed_employee_wiser_id is not null
        and pr_repository_area is not null
        and pr_merged_before_created = 0
    group by 1, 2
),
first_prs as (
    select
        o.wiser_id,
        o.squad,
        p.pr_repository,
        p.pr_repository_name,
        p.pr_repository_area,
        p.pr_cycle_time_days as first_pr_cycle_time_days
    from productivity.onboarding_summary o
    inner join productivity.pull_requests p
        on o.first_pr_id = p.pr_id
    where o.is_true_onboarding_metric = true
        and o.role_productivity_category = 'Software Engineering'
        and o.employee_type = 'Permanent'
        and p.pr_merged_before_created = 0
),
joined as (
    select
        f.*,
        r.repo_median_cycle_time_days,
        a.squad_area_median_cycle_time_days
    from first_prs f
    left join repo_baselines r
        on f.pr_repository = r.pr_repository
        and f.pr_repository_area = r.pr_repository_area
    left join area_baselines a
        on f.squad = a.squad
        and f.pr_repository_area = a.pr_repository_area
)
select
    'New-hire first PR vs same repo baseline' as comparison,
    count(*) as prs,
    median(first_pr_cycle_time_days) as first_pr_median_cycle_time_days,
    median(repo_median_cycle_time_days) as baseline_median_cycle_time_days,
    median(first_pr_cycle_time_days - repo_median_cycle_time_days) as median_delta_cycle_time_days,
    avg(case when first_pr_cycle_time_days < repo_median_cycle_time_days then 1.0 else 0.0 end) as pct_faster_than_baseline,
    avg(case when first_pr_cycle_time_days > repo_median_cycle_time_days then 1.0 else 0.0 end) as pct_slower_than_baseline
from joined

union all

select
    'New-hire first PR vs same squad-area baseline' as comparison,
    count(*) as prs,
    median(first_pr_cycle_time_days) as first_pr_median_cycle_time_days,
    median(squad_area_median_cycle_time_days) as baseline_median_cycle_time_days,
    median(first_pr_cycle_time_days - squad_area_median_cycle_time_days) as median_delta_cycle_time_days,
    avg(case when first_pr_cycle_time_days < squad_area_median_cycle_time_days then 1.0 else 0.0 end) as pct_faster_than_baseline,
    avg(case when first_pr_cycle_time_days > squad_area_median_cycle_time_days then 1.0 else 0.0 end) as pct_slower_than_baseline
from joined
