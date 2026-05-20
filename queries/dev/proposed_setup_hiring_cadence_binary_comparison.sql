with base as (
    select
        days_to_first_pr,
        case
            when '${inputs.cadence_context.value}' = 'office' then coalesce(office_other_hires_within_30_days, 0)
            else coalesce(squad_other_hires_within_30_days, 0)
        end as other_hires_within_30_days,
        case
            when '${inputs.cadence_context.value}' = 'office' then coalesce(office_nearest_hire_gap_days, 9999)
            else coalesce(squad_nearest_hire_gap_days, 9999)
        end as nearest_hire_gap_days
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category like '${inputs.role_productivity_category.value}'
      and employee_type like '${inputs.employee_type.value}'
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
      and days_to_first_pr is not null
),
grouped as (
    select
        case
            when other_hires_within_30_days > 0 then 'Had another similar hire within 30 days'
            else 'No other similar hire within 30 days'
        end as comparison_group,
        case
            when other_hires_within_30_days > 0 then 1
            else 2
        end as sort_order,
        count(*) as hires,
        round(median(days_to_first_pr), 1) as median_days_to_first_pr,
        round(avg(days_to_first_pr), 1) as mean_days_to_first_pr,
        round(quantile_cont(days_to_first_pr, 0.75), 1) as p75_days_to_first_pr,
        round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_within_30_days,
        round(avg(nearest_hire_gap_days), 1) as avg_nearest_hire_gap_days
    from base
    group by 1, 2
)
select *
from grouped
order by sort_order
