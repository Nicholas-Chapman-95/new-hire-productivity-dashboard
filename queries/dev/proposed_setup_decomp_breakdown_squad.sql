with filtered as (
    select cohort_month, squad as group_label, days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
      and squad is not null
),
reference_totals as (
    select count(*) as total_hires from filtered
),
selected_totals as (
    select count(*) as total_hires from filtered where cohort_month = '${inputs.cohort_month.value}'
),
reference_by_group as (
    select
        group_label,
        count(*) as reference_hires,
        case
            when '${inputs.metric.value}' = 'pct_30' then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as reference_metric_value
    from filtered
    group by 1
),
selected_by_group as (
    select
        group_label,
        count(*) as selected_hires,
        case
            when '${inputs.metric.value}' = 'pct_30' then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as selected_metric_value
    from filtered
    where cohort_month = '${inputs.cohort_month.value}'
    group by 1
)
select
    r.group_label,
    coalesce(s.selected_hires, 0) as selected_hires,
    r.reference_hires,
    round(coalesce(s.selected_hires, 0) * 100.0 / st.total_hires, 1) as selected_share_pct,
    round(r.reference_hires * 100.0 / rt.total_hires, 1) as reference_share_pct,
    round(coalesce(s.selected_metric_value, r.reference_metric_value), 1) as selected_metric_value,
    round(r.reference_metric_value, 1) as reference_metric_value,
    round(((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) - (r.reference_hires * 1.0 / rt.total_hires)) * r.reference_metric_value, 2) as mix_component,
    round((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) * (coalesce(s.selected_metric_value, r.reference_metric_value) - r.reference_metric_value), 2) as rate_component,
    round(
        (((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) - (r.reference_hires * 1.0 / rt.total_hires)) * r.reference_metric_value)
        + ((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) * (coalesce(s.selected_metric_value, r.reference_metric_value) - r.reference_metric_value)),
        2
    ) as total_contribution
from reference_by_group r
left join selected_by_group s using (group_label)
cross join reference_totals rt
cross join selected_totals st
where st.total_hires > 0
order by abs(total_contribution) desc, group_label
