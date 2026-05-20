with filtered as (
    select *
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
        *,
        case
            when '${inputs.day_basis.value}' = 'business' then 20
            else 30
        end as completion_threshold,
        case
            when '${inputs.day_basis.value}' = 'business' then business_days_to_first_pr
            else days_to_first_pr
        end as selected_days_to_first_pr
    from filtered
),
grouped as (
    select
        case
            when '${inputs.breakdown_by.value}' = 'office' then office
            when '${inputs.breakdown_by.value}' = 'level' then 'L' || cast(management_level as varchar)
            when '${inputs.breakdown_by.value}' = 'sub_team' then sub_team
            else squad
        end as group_label,
        case
            when '${inputs.breakdown_by.value}' = 'level' then management_level
            else null
        end as sort_key,
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
                    when '${inputs.day_basis.value}' <> 'business'
                        and days_since_hire >= completion_threshold
                        and days_to_first_pr <= completion_threshold then 1.0
                    when '${inputs.day_basis.value}' <> 'business'
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
    group by 1, 2
)
select *
from grouped
order by
    case when sort_key is null then hires end desc,
    sort_key,
    group_label
