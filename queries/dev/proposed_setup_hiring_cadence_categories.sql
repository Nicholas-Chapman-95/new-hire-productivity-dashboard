with onboarding as (
    select
        wiser_id,
        office,
        squad,
        hire_date,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category like '${inputs.role_productivity_category.value}'
      and employee_type like '${inputs.employee_type.value}'
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
      and days_to_first_pr is not null
      and cohort_month >= '2025-03'
),
nearest as (
    select
        o1.wiser_id,
        min(abs(date_diff('day', o1.hire_date, o2.hire_date))) as nearest_other_hire_gap_days
    from onboarding o1
    left join onboarding o2
      on (
            ('${inputs.cadence_context.value}' = 'office' and o1.office = o2.office)
         or ('${inputs.cadence_context.value}' != 'office' and o1.squad = o2.squad)
      )
     and o1.wiser_id != o2.wiser_id
    group by 1
),
categorized as (
    select
        o.wiser_id,
        o.days_to_first_pr,
        case
            when n.nearest_other_hire_gap_days is null then 'No other hire within 180 days'
            when n.nearest_other_hire_gap_days <= 30 then 'Joined within 0-30 days'
            when n.nearest_other_hire_gap_days <= 60 then 'Joined within 31-60 days'
            when n.nearest_other_hire_gap_days <= 90 then 'Joined within 61-90 days'
            when n.nearest_other_hire_gap_days <= 180 then 'Joined within 91-180 days'
            else 'No other hire within 180 days'
        end as cadence_category,
        case
            when n.nearest_other_hire_gap_days is null then 5
            when n.nearest_other_hire_gap_days <= 30 then 1
            when n.nearest_other_hire_gap_days <= 60 then 2
            when n.nearest_other_hire_gap_days <= 90 then 3
            when n.nearest_other_hire_gap_days <= 180 then 4
            else 5
        end as sort_order
    from onboarding o
    left join nearest n
      on o.wiser_id = n.wiser_id
)
select
    cadence_category,
    sort_order,
    count(*) as hires,
    round(avg(days_to_first_pr), 1) as average_days_to_first_pr,
    round(median(days_to_first_pr), 1) as median_days_to_first_pr,
    round(quantile_cont(days_to_first_pr, 0.25), 1) as p25_days_to_first_pr,
    round(quantile_cont(days_to_first_pr, 0.75), 1) as p75_days_to_first_pr,
    round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_within_30_days
from categorized
group by 1, 2
order by sort_order
