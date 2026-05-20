with filtered as (
    select
        *,
        cast(cohort_month || '-01' as date) as cohort_date,
        case
            when '${inputs.comparison_grain.value}' = 'half'
                then cast(extract(year from cast(cohort_month || '-01' as date)) as varchar) || ' H' ||
                    case when extract(month from cast(cohort_month || '-01' as date)) <= 6 then '1' else '2' end
            else cohort_month
        end as period_key
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
),
reference_metric as (
    select
        count(*) as reference_hires,
        case
            when '${inputs.metric.value}' = 'pct_30'
                then round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1)
            else round(avg(days_to_first_pr), 1)
        end as reference_value
    from filtered
    where period_key = '${inputs.reference_period.value}'
),
selected_metric as (
    select
        count(*) as selected_hires,
        case
            when '${inputs.metric.value}' = 'pct_30'
                then round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1)
            else round(avg(days_to_first_pr), 1)
        end as selected_value
    from filtered
    where period_key = '${inputs.selected_period.value}'
)
select
    selected_hires,
    reference_hires,
    selected_value,
    reference_value,
    round(selected_value - reference_value, 1) as delta_value
from selected_metric
cross join reference_metric
