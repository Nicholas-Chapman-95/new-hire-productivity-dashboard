select
    day_window,
    day_window_label,
    count(*) as fully_observed_hires,
    median(pct_of_local_benchmark) as median_pct_of_pooled_benchmark,
    median(pct_of_contemporaneous_benchmark) as median_pct_of_contemporaneous_benchmark,
    avg(case when has_hit_local_benchmark = 1 then 1.0 else 0.0 end) as hit_local_benchmark_rate
from productivity.exact_ramp_windows
where role_productivity_category = 'Software Engineering'
  and employee_type = 'Permanent'
  and is_true_onboarding_metric = true
  and in_reliability_window = 1
  and is_window_fully_observed = 1
group by 1, 2
order by 1
