select
    day_window,
    day_window_label,
    count(*) as fully_observed_hires,
    median(local_team_pr_share_index) as median_local_team_pr_share_index,
    median(local_team_pr_share) as median_local_team_pr_share,
    median(local_team_active_engineers) as median_local_team_active_engineers
from productivity.exact_ramp_windows
where role_productivity_category = 'Software Engineering'
  and employee_type = 'Permanent'
  and is_true_onboarding_metric = true
  and in_reliability_window = 1
  and is_window_fully_observed = 1
  and local_team_pr_share_index is not null
group by 1, 2
order by 1
