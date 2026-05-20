with filtered as (
    select
        days_to_first_pr,
        business_days_to_first_pr,
        days_since_hire,
        business_days_since_hire
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category like '${inputs.role_productivity_category.value}'
      and employee_type like '${inputs.employee_type.value}'
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
),
scored as (
    select
        days_to_first_pr,
        business_days_to_first_pr,
        days_since_hire,
        business_days_since_hire,
        case
            when '${inputs.day_basis.value}' = 'business' then 20
            else 30
        end as completion_threshold,
        case
            when '${inputs.day_basis.value}' = 'business' then business_days_to_first_pr
            else days_to_first_pr
        end as selected_days_to_first_pr
    from filtered
)
select
    count(*) as hires,
    sum(
        case
            when '${inputs.day_basis.value}' = 'business' and business_days_since_hire >= completion_threshold then 1
            when '${inputs.day_basis.value}' != 'business' and days_since_hire >= completion_threshold then 1
            else 0
        end
    ) as observed_30d_hires,
    sum(
        case
            when '${inputs.day_basis.value}' = 'business'
             and business_days_since_hire >= completion_threshold
             and business_days_to_first_pr <= completion_threshold then 1
            when '${inputs.day_basis.value}' != 'business'
             and days_since_hire >= completion_threshold
             and days_to_first_pr <= completion_threshold then 1
            else 0
        end
    ) as completed_30d_hires,
    round(median(selected_days_to_first_pr), 1) as median_days_to_first_pr,
    round(avg(selected_days_to_first_pr), 1) as average_days_to_first_pr,
    round(
        avg(
            case
                when '${inputs.day_basis.value}' = 'business'
                 and business_days_since_hire >= completion_threshold
                 and business_days_to_first_pr <= completion_threshold then 1.0
                when '${inputs.day_basis.value}' = 'business'
                 and business_days_since_hire >= completion_threshold then 0.0
                when '${inputs.day_basis.value}' != 'business'
                 and days_since_hire >= completion_threshold
                 and days_to_first_pr <= completion_threshold then 1.0
                when '${inputs.day_basis.value}' != 'business'
                 and days_since_hire >= completion_threshold then 0.0
            end
        ) * 100,
        1
    ) as pct_within_30_days,
    round(quantile_cont(selected_days_to_first_pr, 0.25), 1) as p25_days_to_first_pr,
    round(quantile_cont(selected_days_to_first_pr, 0.75), 1) as p75_days_to_first_pr,
    round(quantile_cont(selected_days_to_first_pr, 0.75) - quantile_cont(selected_days_to_first_pr, 0.25), 1) as iqr_days_to_first_pr
from scored
where selected_days_to_first_pr is not null
