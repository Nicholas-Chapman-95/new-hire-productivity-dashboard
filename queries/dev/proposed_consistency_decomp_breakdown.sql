with filtered as (
    select
        case
            when '${inputs.comparison_grain.value}' = 'half'
                then cast(extract(year from cast(cohort_month || '-01' as date)) as varchar) || ' H' ||
                    case when extract(month from cast(cohort_month || '-01' as date)) <= 6 then '1' else '2' end
            else cohort_month
        end as period_key,
        case
            when '${inputs.dimension.value}' = 'office' then office
            when '${inputs.dimension.value}' = 'level' then 'L' || cast(management_level as varchar)
            when '${inputs.dimension.value}' = 'sub_team' then sub_team
            else squad
        end as group_label,
        case
            when '${inputs.dimension.value}' = 'level' then management_level
            else null
        end as sort_key,
        days_to_first_pr
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
reference_totals as (
    select count(*) as total_hires
    from filtered
    where period_key = '${inputs.reference_period.value}'
),
selected_totals as (
    select count(*) as total_hires
    from filtered
    where period_key = '${inputs.selected_period.value}'
),
reference_by_group as (
    select
        group_label,
        min(sort_key) as sort_key,
        count(*) as reference_hires,
        case
            when '${inputs.metric.value}' = 'pct_30'
                then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as reference_metric_value
    from filtered
    where period_key = '${inputs.reference_period.value}'
    group by 1
),
selected_by_group as (
    select
        group_label,
        min(sort_key) as sort_key,
        count(*) as selected_hires,
        case
            when '${inputs.metric.value}' = 'pct_30'
                then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as selected_metric_value
    from filtered
    where period_key = '${inputs.selected_period.value}'
    group by 1
),
all_dimension_groups as (
    select group_label, sort_key from reference_by_group
    union
    select group_label, sort_key from selected_by_group
)
select
    g.group_label,
    coalesce(s.sort_key, r.sort_key, g.sort_key) as sort_key,
    coalesce(s.selected_hires, 0) as selected_hires,
    coalesce(r.reference_hires, 0) as reference_hires,
    round(coalesce(s.selected_hires, 0) * 100.0 / st.total_hires, 1) as selected_share_pct,
    round(coalesce(r.reference_hires, 0) * 100.0 / rt.total_hires, 1) as reference_share_pct,
    round(coalesce(s.selected_metric_value, r.reference_metric_value), 1) as selected_metric_value,
    round(coalesce(r.reference_metric_value, s.selected_metric_value), 1) as reference_metric_value,
    round(((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) - (coalesce(r.reference_hires, 0) * 1.0 / rt.total_hires)) * coalesce(r.reference_metric_value, s.selected_metric_value), 2) as mix_component,
    round((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) * (coalesce(s.selected_metric_value, r.reference_metric_value) - coalesce(r.reference_metric_value, s.selected_metric_value)), 2) as rate_component,
    round(
        (((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) - (coalesce(r.reference_hires, 0) * 1.0 / rt.total_hires)) * coalesce(r.reference_metric_value, s.selected_metric_value))
        + ((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) * (coalesce(s.selected_metric_value, r.reference_metric_value) - coalesce(r.reference_metric_value, s.selected_metric_value))),
        2
    ) as total_contribution
from all_dimension_groups g
left join reference_by_group r using (group_label)
left join selected_by_group s using (group_label)
cross join reference_totals rt
cross join selected_totals st
where st.total_hires > 0
  and rt.total_hires > 0
order by abs(total_contribution) desc, sort_key, group_label
