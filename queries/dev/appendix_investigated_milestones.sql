with filtered as (
    select *
    from productivity.hire_pr_progression
    where is_true_onboarding_metric = true
      and in_reliability_window = 1
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
),
per_employee as (
    select
        wiser_id,
        max(case when employee_pr_rank = 5 then days_since_hire_at_merge end) as days_to_fifth_pr,
        max(case when employee_pr_rank = 10 then days_since_hire_at_merge end) as days_to_tenth_pr
    from filtered
    group by 1
)
select
    count(*) filter (where days_to_fifth_pr is not null) as hires,
    round(median(days_to_fifth_pr), 1) as median_days_to_fifth_pr,
    round(median(days_to_tenth_pr), 1) as median_days_to_tenth_pr,
    round(avg(case when days_to_fifth_pr <= 60 then 1.0 else 0.0 end) * 100, 1) as pct_to_fifth_by_60,
    round(avg(case when days_to_tenth_pr <= 90 then 1.0 else 0.0 end) * 100, 1) as pct_to_tenth_by_90
from per_employee
where days_to_fifth_pr is not null
