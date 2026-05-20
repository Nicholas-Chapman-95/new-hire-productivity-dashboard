with filtered as (
    select
        cohort_month,
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
),
selected_totals as (
    select cohort_month, count(*) as total_hires
    from filtered
    group by 1
),
all_groups as (
    select 'squad' as dimension, squad as group_label, cohort_month, days_to_first_pr
    from filtered
    where squad is not null
    union all
    select 'sub_team' as dimension, sub_team as group_label, cohort_month, days_to_first_pr
    from filtered
    where sub_team is not null
    union all
    select 'office' as dimension, office as group_label, cohort_month, days_to_first_pr
    from filtered
    where office is not null
    union all
    select 'level' as dimension, level_label as group_label, cohort_month, days_to_first_pr
    from filtered
    where management_level is not null
),
reference_by_group as (
    select
        dimension,
        group_label,
        count(*) as reference_hires,
        case
            when '${inputs.metric.value}' = 'pct_30' then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as reference_metric_value
    from all_groups
    group by 1, 2
),
selected_by_group as (
    select
        cohort_month,
        dimension,
        group_label,
        count(*) as selected_hires,
        case
            when '${inputs.metric.value}' = 'pct_30' then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as selected_metric_value
    from all_groups
    group by 1, 2, 3
),
contributions as (
    select
        s.cohort_month,
        s.dimension,
        s.group_label,
        round(
            (((s.selected_hires * 1.0 / st.total_hires) - (r.reference_hires * 1.0 / rt.total_hires)) * r.reference_metric_value)
            + ((s.selected_hires * 1.0 / st.total_hires) * (s.selected_metric_value - r.reference_metric_value)),
            2
        ) as total_contribution
    from selected_by_group s
    join reference_by_group r
      on s.dimension = r.dimension
     and s.group_label = r.group_label
    join selected_totals st using (cohort_month)
    cross join reference_totals rt
),
ranked as (
    select
        *,
        row_number() over (partition by cohort_month order by total_contribution desc, dimension, group_label) as positive_rank,
        row_number() over (partition by cohort_month order by total_contribution asc, dimension, group_label) as negative_rank
    from contributions
)
select
    cast(cohort_month || '-01' as date) as cohort_date,
    cohort_month,
    'Top Upward Pull' as series,
    max(case when positive_rank = 1 then total_contribution end) as contribution,
    max(case when positive_rank = 1 then dimension || ': ' || group_label end) as driver_label
from ranked
group by 1, 2
union all
select
    cast(cohort_month || '-01' as date) as cohort_date,
    cohort_month,
    'Top Downward Pull' as series,
    max(case when negative_rank = 1 then total_contribution end) as contribution,
    max(case when negative_rank = 1 then dimension || ': ' || group_label end) as driver_label
from ranked
group by 1, 2
order by cohort_month, series
