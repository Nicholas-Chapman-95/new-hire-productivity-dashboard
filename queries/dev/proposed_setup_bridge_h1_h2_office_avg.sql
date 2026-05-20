with filtered as (
    select
        case
            when cohort_month between '2025-03' and '2025-08' then '2025-03 to 2025-08'
            when cohort_month between '2025-09' and '2026-02' then '2025-09 to 2026-02'
        end as period_key,
        case
            when '${inputs.compare_dimension.value}' = 'cross_office_squad_status' then cross_office_squad_status
            else office
        end as group_label,
        case
            when '${inputs.day_basis.value}' = 'business' then business_days_to_first_pr
            else days_to_first_pr
        end as selected_days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and cohort_month between '2025-03' and '2026-02'
),
reference_totals as (
    select count(*) as total_hires
    from filtered
    where period_key = '2025-03 to 2025-08'
      and selected_days_to_first_pr is not null
),
selected_totals as (
    select count(*) as total_hires
    from filtered
    where period_key = '2025-09 to 2026-02'
      and selected_days_to_first_pr is not null
),
reference_by_group as (
    select
        group_label,
        count(*) as reference_hires,
        avg(selected_days_to_first_pr) as reference_metric_value
    from filtered
    where period_key = '2025-03 to 2025-08'
      and selected_days_to_first_pr is not null
    group by 1
),
selected_by_group as (
    select
        group_label,
        count(*) as selected_hires,
        avg(selected_days_to_first_pr) as selected_metric_value
    from filtered
    where period_key = '2025-09 to 2026-02'
      and selected_days_to_first_pr is not null
    group by 1
),
all_groups as (
    select group_label from reference_by_group
    union
    select group_label from selected_by_group
)
select
    g.group_label,
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
  and g.group_label is not null
order by abs(total_contribution) desc, group_label
