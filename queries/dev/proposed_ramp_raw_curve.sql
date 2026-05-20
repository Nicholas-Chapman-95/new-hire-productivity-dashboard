select
    day_window,
    day_window_label,
    count(*) as fully_observed_hires,
    quantile_cont(pr_count, 0.25) as p25_pr_count,
    median(pr_count) as median_pr_count,
    quantile_cont(pr_count, 0.75) as p75_pr_count,
    avg(pr_count) as mean_pr_count
from productivity.exact_ramp_windows
where role_productivity_category = 'Software Engineering'
  and employee_type = 'Permanent'
  and is_true_onboarding_metric = true
  and in_reliability_window = 1
  and is_window_fully_observed = 1
group by 1, 2
order by 1
