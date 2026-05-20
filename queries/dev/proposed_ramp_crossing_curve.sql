with base as (
    select
        day_window,
        day_window_label,
        median(pr_count) as median_new_hire_prs,
        median(benchmark_prs) as median_local_benchmark_prs,
        median(contemporaneous_benchmark_prs) as median_same_month_benchmark_prs
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
      and is_window_fully_observed = 1
    group by 1, 2
)
select
    day_window,
    day_window_label,
    'Median new-hire PRs' as series,
    median_new_hire_prs as pr_count
from base

union all

select
    day_window,
    day_window_label,
    'Median local benchmark' as series,
    median_local_benchmark_prs as pr_count
from base

union all

select
    day_window,
    day_window_label,
    'Median same-month benchmark' as series,
    median_same_month_benchmark_prs as pr_count
from base

order by day_window, series
