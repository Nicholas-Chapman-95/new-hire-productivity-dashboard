with filtered as (
    select
        office,
        holiday_calendar_code,
        holiday_calendar_configured,
        days_to_first_pr,
        business_days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and first_pr_merged_at is not null
)
select
    count(*) as hires,
    sum(case when holiday_calendar_configured = 1 then 1 else 0 end) as configured_hires,
    sum(case when holiday_calendar_configured = 0 then 1 else 0 end) as fallback_hires,
    round(median(days_to_first_pr), 1) as median_calendar_days,
    round(median(business_days_to_first_pr), 1) as median_business_days,
    round(median(days_to_first_pr - business_days_to_first_pr), 1) as median_gap_days,
    round(avg(days_to_first_pr - business_days_to_first_pr), 1) as average_gap_days
from filtered
