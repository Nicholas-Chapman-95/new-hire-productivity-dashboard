select
    squad,
    count(*) as hires,
    round(avg(days_to_first_pr), 1) as mean_days_to_first_pr,
    round(median(days_to_first_pr), 1) as median_days_to_first_pr,
    round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_within_30_days
from productivity.onboarding_summary
where is_true_onboarding_metric = true
  and role_productivity_category = 'Software Engineering'
  and employee_type = 'Permanent'
  and days_to_first_pr is not null
group by 1
order by hires desc, squad
