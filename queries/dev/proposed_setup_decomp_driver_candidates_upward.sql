with filtered as (
    select
        case
            when '${inputs.comparison_grain.value}' = 'half'
                then cast(extract(year from cast(cohort_month || '-01' as date)) as varchar) || ' H' ||
                    case when extract(month from cast(cohort_month || '-01' as date)) <= 6 then '1' else '2' end
            else cohort_month
        end as period_key,
        office,
        sub_team,
        squad,
        'L' || cast(management_level as varchar) as level_label,
        management_level,
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
all_groups as (
    select 'squad' as dimension, squad as group_label, null::integer as sort_key, period_key, days_to_first_pr
    from filtered where squad is not null
    union all
    select 'sub_team' as dimension, sub_team as group_label, null::integer as sort_key, period_key, days_to_first_pr
    from filtered where sub_team is not null
    union all
    select 'office' as dimension, office as group_label, null::integer as sort_key, period_key, days_to_first_pr
    from filtered where office is not null
    union all
    select 'level' as dimension, level_label as group_label, management_level as sort_key, period_key, days_to_first_pr
    from filtered where management_level is not null
),
reference_by_group as (
    select
        dimension,
        group_label,
        min(sort_key) as sort_key,
        count(*) as reference_hires,
        case
            when '${inputs.metric.value}' = 'pct_30'
                then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as reference_metric_value
    from all_groups
    where period_key = '${inputs.reference_period.value}'
    group by 1, 2
),
selected_by_group as (
    select
        dimension,
        group_label,
        min(sort_key) as sort_key,
        count(*) as selected_hires,
        case
            when '${inputs.metric.value}' = 'pct_30'
                then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as selected_metric_value
    from all_groups
    where period_key = '${inputs.selected_period.value}'
    group by 1, 2
),
all_dimension_groups as (
    select dimension, group_label, sort_key from reference_by_group
    union
    select dimension, group_label, sort_key from selected_by_group
),
ranked as (
    select
        g.dimension,
        g.group_label,
        coalesce(s.sort_key, r.sort_key, g.sort_key) as sort_key,
        coalesce(s.selected_hires, 0) as selected_hires,
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
)
select
    dimension,
    group_label,
    selected_hires,
    selected_metric_value,
    reference_metric_value,
    mix_component,
    rate_component,
    total_contribution
from ranked
where total_contribution > 0
order by total_contribution desc, dimension, group_label
