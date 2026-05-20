with monthly as (
    select
        cohort_month,
        cast(cohort_month || '-01' as date) as cohort_date,
        round(median(selected_days_to_first_pr), 1) as median_days,
        round(avg(selected_days_to_first_pr), 1) as average_days,
        round(quantile_cont(selected_days_to_first_pr, 0.25), 1) as p25_days,
        round(quantile_cont(selected_days_to_first_pr, 0.75), 1) as p75_days
    from productivity.onboarding_summary
    cross join lateral (
        select
            case
                when '${inputs.day_basis.value}' = 'business' then business_days_to_first_pr
                else days_to_first_pr
            end as selected_days_to_first_pr
    )
    where is_true_onboarding_metric = true
      and role_productivity_category like '${inputs.role_productivity_category.value}'
      and employee_type like '${inputs.employee_type.value}'
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
      and selected_days_to_first_pr is not null
    group by 1, 2
)
select cohort_month, cohort_date, 'Median' as series, median_days as days from monthly
union all
select cohort_month, cohort_date, 'Average' as series, average_days as days from monthly
union all
select cohort_month, cohort_date, 'P25' as series, p25_days as days from monthly
union all
select cohort_month, cohort_date, 'P75' as series, p75_days as days from monthly
