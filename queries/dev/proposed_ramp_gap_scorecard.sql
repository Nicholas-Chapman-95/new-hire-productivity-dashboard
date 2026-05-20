with windows as (
    select
        day_window,
        median(pr_count) as median_new_hire_prs,
        median(contemporaneous_benchmark_prs) as median_same_month_benchmark_prs
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
      and is_window_fully_observed = 1
      and day_window in (0, 1)
    group by 1
),
summary as (
    select
        max(case when day_window = 0 then median_new_hire_prs end) as median_new_hire_prs_0_29,
        max(case when day_window = 0 then median_same_month_benchmark_prs end) as median_same_month_benchmark_prs_0_29,
        max(case when day_window = 1 then median_new_hire_prs end) as median_new_hire_prs_30_59,
        max(case when day_window = 1 then median_same_month_benchmark_prs end) as median_same_month_benchmark_prs_30_59
    from windows
)
select
    median_new_hire_prs_0_29,
    median_same_month_benchmark_prs_0_29,
    median_new_hire_prs_0_29 - median_same_month_benchmark_prs_0_29 as gap_prs_0_29,
    median_new_hire_prs_30_59,
    median_same_month_benchmark_prs_30_59,
    median_new_hire_prs_30_59 - median_same_month_benchmark_prs_30_59 as gap_prs_30_59
from summary
