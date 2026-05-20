select
    case
        when '${inputs.comparison_grain.value}' = 'half'
            then cast(extract(year from cast(cohort_month || '-01' as date)) as varchar) || ' H' ||
                case when extract(month from cast(cohort_month || '-01' as date)) <= 6 then '1' else '2' end
        else cohort_month
    end as period_key,
    case
        when '${inputs.comparison_grain.value}' = 'half'
            then make_date(
                cast(extract(year from cast(cohort_month || '-01' as date)) as integer),
                case when extract(month from cast(cohort_month || '-01' as date)) <= 6 then 1 else 7 end,
                1
            )
        else cast(cohort_month || '-01' as date)
    end as period_start,
    count(*) as hires,
    case
        when '${inputs.metric.value}' = 'pct_30'
            then round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1)
        else round(avg(days_to_first_pr), 1)
    end as metric_value
from productivity.onboarding_summary
where is_true_onboarding_metric = true
  and role_productivity_category = 'Software Engineering'
  and employee_type = 'Permanent'
  and days_to_first_pr is not null
  and office like '${inputs.office.value}'
  and squad like '${inputs.squad.value}'
  and sub_team like '${inputs.sub_team.value}'
  and cast(management_level as varchar) like '${inputs.management_level.value}'
group by 1, 2
order by period_start
