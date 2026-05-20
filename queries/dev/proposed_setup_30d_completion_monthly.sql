with filtered as (
    select
        *,
        case
            when '${inputs.day_basis.value}' = 'business' then 20
            else 30
        end as completion_threshold
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category like '${inputs.role_productivity_category.value}'
      and employee_type like '${inputs.employee_type.value}'
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
),
monthly as (
    select
        cohort_month,
        cast(cohort_month || '-01' as date) as cohort_date,
        count(*) as hires,
        sum(
            case
                when '${inputs.day_basis.value}' = 'business'
                    and business_days_since_hire >= completion_threshold then 1
                when '${inputs.day_basis.value}' <> 'business'
                    and days_since_hire >= completion_threshold then 1
                else 0
            end
        ) as observed_completion_hires,
        sum(
            case
                when '${inputs.day_basis.value}' = 'business'
                    and business_days_since_hire >= completion_threshold
                    and business_days_to_first_pr <= completion_threshold then 1
                when '${inputs.day_basis.value}' <> 'business'
                    and days_since_hire >= completion_threshold
                    and days_to_first_pr <= completion_threshold then 1
                else 0
            end
        ) as completed_completion_hires
    from filtered
    group by 1, 2
)
select
    cohort_month,
    cohort_date,
    hires,
    observed_completion_hires,
    completed_completion_hires,
    round(completed_completion_hires * 100.0 / nullif(observed_completion_hires, 0), 1) as pct_by_threshold
from monthly
where observed_completion_hires > 0
order by cohort_date
