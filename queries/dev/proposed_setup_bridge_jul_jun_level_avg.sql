with filtered as (
    select
        cohort_month,
        'L' || cast(cast(management_level as integer) as varchar) as group_label,
        cast(management_level as integer) as level_order,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and cohort_month in ('2025-06', '2025-07')
),
reference_totals as (
    select count(*) as total_hires
    from filtered
    where cohort_month = '2025-06'
),
selected_totals as (
    select count(*) as total_hires
    from filtered
    where cohort_month = '2025-07'
),
reference_by_group as (
    select
        group_label,
        min(level_order) as level_order,
        count(*) as reference_hires,
        avg(days_to_first_pr) as reference_metric_value
    from filtered
    where cohort_month = '2025-06'
    group by 1
),
selected_by_group as (
    select
        group_label,
        min(level_order) as level_order,
        count(*) as selected_hires,
        avg(days_to_first_pr) as selected_metric_value
    from filtered
    where cohort_month = '2025-07'
    group by 1
),
all_groups as (
    select group_label, level_order from reference_by_group
    union
    select group_label, level_order from selected_by_group
)
select
    g.group_label,
    g.level_order,
    coalesce(s.selected_hires, 0) as selected_hires,
    coalesce(r.reference_hires, 0) as reference_hires,
    round(coalesce(s.selected_metric_value, r.reference_metric_value), 1) as selected_metric_value,
    round(coalesce(r.reference_metric_value, s.selected_metric_value), 1) as reference_metric_value,
    round(
        ((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) - (coalesce(r.reference_hires, 0) * 1.0 / rt.total_hires))
        * coalesce(r.reference_metric_value, s.selected_metric_value),
        2
    ) as mix_component,
    round(
        (coalesce(s.selected_hires, 0) * 1.0 / st.total_hires)
        * (coalesce(s.selected_metric_value, r.reference_metric_value) - coalesce(r.reference_metric_value, s.selected_metric_value)),
        2
    ) as rate_component,
    round(
        (
            ((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) - (coalesce(r.reference_hires, 0) * 1.0 / rt.total_hires))
            * coalesce(r.reference_metric_value, s.selected_metric_value)
        ) + (
            (coalesce(s.selected_hires, 0) * 1.0 / st.total_hires)
            * (coalesce(s.selected_metric_value, r.reference_metric_value) - coalesce(r.reference_metric_value, s.selected_metric_value))
        ),
        2
    ) as total_contribution
from all_groups g
left join reference_by_group r using (group_label)
left join selected_by_group s using (group_label)
cross join reference_totals rt
cross join selected_totals st
where st.total_hires > 0
  and rt.total_hires > 0
order by g.level_order
