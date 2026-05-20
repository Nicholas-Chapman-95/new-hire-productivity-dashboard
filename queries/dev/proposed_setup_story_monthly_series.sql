with monthly as (
    select
        cast(cohort_month || '-01' as date) as cohort_date,
        round(median(days_to_first_pr), 1) as median_days,
        round(avg(days_to_first_pr), 1) as avg_days,
        round(quantile_cont(days_to_first_pr, 0.25), 1) as p25_days,
        round(quantile_cont(days_to_first_pr, 0.75), 1) as p75_days
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and cohort_month >= '2025-03'
    group by 1
)
select cohort_date, 'Median' as series, median_days as days from monthly
union all
select cohort_date, 'Average' as series, avg_days as days from monthly
union all
select cohort_date, 'P25' as series, p25_days as days from monthly
union all
select cohort_date, 'P75' as series, p75_days as days from monthly
