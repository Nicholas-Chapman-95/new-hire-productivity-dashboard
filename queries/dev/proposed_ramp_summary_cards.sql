with hire_benchmark as (
    select
        wiser_id,
        median(benchmark_prs) as benchmark_prs,
        median(benchmark_pr_target) as benchmark_pr_target
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
    group by 1
),
hit as (
    select
        hb.wiser_id,
        min(
            case
                when hb.benchmark_pr_target > 0
                 and hp.employee_pr_rank >= hb.benchmark_pr_target
                    then hp.days_since_hire_at_merge
            end
        ) as days_to_benchmark
    from hire_benchmark hb
    left join productivity.hire_pr_progression hp
        on hb.wiser_id = hp.wiser_id
    group by 1
),
raw_windows as (
    select
        day_window,
        median(pr_count) as median_pr_count
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
      and is_window_fully_observed = 1
      and day_window in (0, 1, 2, 3, 4)
    group by 1
),
raw_summary as (
    select
        max(case when day_window = 0 then median_pr_count end) as median_prs_0_29,
        max(case when day_window = 1 then median_pr_count end) as median_prs_30_59,
        max(case when day_window = 2 then median_pr_count end) as median_prs_60_89,
        max(case when day_window = 3 then median_pr_count end) as median_prs_90_119,
        max(case when day_window = 4 then median_pr_count end) as median_prs_120_149
    from raw_windows
),
benchmark_summary as (
    select
        count(hb.wiser_id) as hires,
        median(h.days_to_benchmark) as median_days_to_benchmark,
        avg(case when h.days_to_benchmark <= 60 then 1.0 else 0.0 end) as benchmark_by_day_60,
        avg(case when h.days_to_benchmark <= 90 then 1.0 else 0.0 end) as benchmark_by_day_90
    from hire_benchmark hb
    left join hit h
        using (wiser_id)
)
select
    bs.hires,
    rs.median_prs_0_29,
    rs.median_prs_30_59,
    rs.median_prs_60_89,
    rs.median_prs_90_119,
    rs.median_prs_120_149,
    bs.median_days_to_benchmark,
    bs.benchmark_by_day_60,
    bs.benchmark_by_day_90
from benchmark_summary bs
cross join raw_summary rs
