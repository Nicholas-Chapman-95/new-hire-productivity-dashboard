with filtered as (
    select
        case
            when '${inputs.bridge_comparison_grain.value}' = 'half'
                then cast(extract(year from cast(cohort_month || '-01' as date)) as varchar) || ' H' ||
                    case when extract(month from cast(cohort_month || '-01' as date)) <= 6 then '1' else '2' end
            else cohort_month
        end as period_key,
        case
            when '${inputs.bridge_dimension.value}' = 'office' then office
            when '${inputs.bridge_dimension.value}' = 'level' then 'L' || cast(management_level as varchar)
            when '${inputs.bridge_dimension.value}' = 'sub_team' then sub_team
            else squad
        end as group_label,
        case
            when '${inputs.bridge_dimension.value}' = 'level' then management_level
            else null
        end as level_order,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
),
reference_totals as (
    select count(*) as total_hires
    from filtered
    where period_key = '${inputs.bridge_reference_period.value}'
),
selected_totals as (
    select count(*) as total_hires
    from filtered
    where period_key = '${inputs.bridge_selected_period.value}'
),
reference_by_group as (
    select
        group_label,
        min(level_order) as ref_level_order,
        count(*) as reference_hires,
        case
            when '${inputs.bridge_metric.value}' = 'pct_30'
                then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as reference_metric_value
    from filtered
    where period_key = '${inputs.bridge_reference_period.value}'
    group by 1
),
selected_by_group as (
    select
        group_label,
        min(level_order) as sel_level_order,
        count(*) as selected_hires,
        case
            when '${inputs.bridge_metric.value}' = 'pct_30'
                then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as selected_metric_value
    from filtered
    where period_key = '${inputs.bridge_selected_period.value}'
    group by 1
),
all_dimension_groups as (
    select group_label, ref_level_order as base_level_order from reference_by_group
    union
    select group_label, sel_level_order as base_level_order from selected_by_group
)
select
    g.group_label,
    coalesce(s.sel_level_order, r.ref_level_order, g.base_level_order) as order_sort_key,
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
order by
    case when '${inputs.bridge_dimension.value}' = 'level' then coalesce(s.sel_level_order, r.ref_level_order, g.base_level_order) end,
    case when '${inputs.bridge_dimension.value}' != 'level' then abs(total_contribution) end desc,
    group_label
