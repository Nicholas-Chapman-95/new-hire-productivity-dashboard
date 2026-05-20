select
    cohort_month,
    cast(cohort_month || '-01' as date) as cohort_date,
    count(*) as hires,
    round(median(days_to_first_pr), 1) as median_days_to_first_pr,
    round(avg(days_to_first_pr), 1) as average_days_to_first_pr,
    round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_within_30_days,
    round(stddev_samp(days_to_first_pr), 1) as sd_days_to_first_pr,
    round(quantile_cont(days_to_first_pr, 0.25), 1) as p25_days_to_first_pr,
    round(quantile_cont(days_to_first_pr, 0.75), 1) as p75_days_to_first_pr,
    round(quantile_cont(days_to_first_pr, 0.75) - quantile_cont(days_to_first_pr, 0.25), 1) as iqr_days_to_first_pr
from productivity.onboarding_summary
where is_true_onboarding_metric = true
  and role_productivity_category like '${inputs.role_productivity_category.value}'
  and employee_type like '${inputs.employee_type.value}'
  and office like '${inputs.office.value}'
  and squad like '${inputs.squad.value}'
  and sub_team like '${inputs.sub_team.value}'
  and cast(management_level as varchar) like '${inputs.management_level.value}'
  and days_to_first_pr is not null
group by 1
order by cohort_month
