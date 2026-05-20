with filtered as (
    select
        case
            when cohort_month between '2025-03' and '2025-08' then '2025-03 to 2025-08'
            when cohort_month between '2025-09' and '2026-02' then '2025-09 to 2026-02'
        end as period_key,
        office,
        sub_team,
        squad,
        'L' || cast(cast(management_level as integer) as varchar) as level_label,
        cast(management_level as integer) as management_level,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and cohort_month between '2025-03' and '2026-02'
),
reference_totals as (
    select count(*) as total_hires
    from filtered
    where period_key = '2025-03 to 2025-08'
),
selected_totals as (
    select count(*) as total_hires
    from filtered
    where period_key = '2025-09 to 2026-02'
),
all_groups as (
    select 'squad' as dimension, 'Squad' as dimension_label, squad as group_label, null::integer as sort_key, period_key, days_to_first_pr
    from filtered
    where squad is not null

    union all

    select 'sub_team' as dimension, 'Sub-Team' as dimension_label, sub_team as group_label, null::integer as sort_key, period_key, days_to_first_pr
    from filtered
    where sub_team is not null

    union all

    select 'office' as dimension, 'Office' as dimension_label, office as group_label, null::integer as sort_key, period_key, days_to_first_pr
    from filtered
    where office is not null

    union all

    select 'level' as dimension, 'Level' as dimension_label, level_label as group_label, management_level as sort_key, period_key, days_to_first_pr
    from filtered
    where management_level is not null
),
reference_by_group as (
    select
        dimension,
        dimension_label,
        group_label,
        min(sort_key) as sort_key,
        count(*) as reference_hires,
        avg(days_to_first_pr) as reference_metric_value
    from all_groups
    where period_key = '2025-03 to 2025-08'
    group by 1, 2, 3
),
selected_by_group as (
    select
        dimension,
        dimension_label,
        group_label,
        min(sort_key) as sort_key,
        count(*) as selected_hires,
        avg(days_to_first_pr) as selected_metric_value
    from all_groups
    where period_key = '2025-09 to 2026-02'
    group by 1, 2, 3
),
all_dimension_groups as (
    select dimension, dimension_label, group_label, sort_key from reference_by_group
    union
    select dimension, dimension_label, group_label, sort_key from selected_by_group
),
ranked as (
    select
        row_number() over (
            order by total_contribution desc, dimension, sort_key, group_label
        ) as contribution_rank,
        dimension,
        dimension_label,
        group_label,
        reference_hires,
        selected_hires,
        reference_metric_value,
        selected_metric_value,
        mix_component,
        rate_component,
        total_contribution
    from (
        select
            g.dimension,
            g.dimension_label,
            g.group_label,
            coalesce(s.sort_key, r.sort_key, g.sort_key) as sort_key,
            coalesce(r.reference_hires, 0) as reference_hires,
            coalesce(s.selected_hires, 0) as selected_hires,
            round(coalesce(r.reference_metric_value, s.selected_metric_value), 1) as reference_metric_value,
            round(coalesce(s.selected_metric_value, r.reference_metric_value), 1) as selected_metric_value,
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
                )
                + (
                    (coalesce(s.selected_hires, 0) * 1.0 / st.total_hires)
                    * (coalesce(s.selected_metric_value, r.reference_metric_value) - coalesce(r.reference_metric_value, s.selected_metric_value))
                ),
                2
            ) as total_contribution
        from all_dimension_groups g
        left join reference_by_group r
          on g.dimension = r.dimension
         and g.group_label = r.group_label
        left join selected_by_group s
          on g.dimension = s.dimension
         and g.group_label = s.group_label
        cross join reference_totals rt
        cross join selected_totals st
        where st.total_hires > 0
          and rt.total_hires > 0
          and coalesce(r.reference_hires, 0) + coalesce(s.selected_hires, 0) >= 3
    ) scored
    where total_contribution > 0
)
select
    contribution_rank,
    dimension,
    dimension_label,
    group_label,
    reference_hires,
    selected_hires,
    reference_metric_value,
    selected_metric_value,
    mix_component,
    rate_component,
    total_contribution
from ranked
where contribution_rank <= 5
order by contribution_rank
