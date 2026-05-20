with filtered as (
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
        case
            when '${inputs.dimension.value}' = 'office' then office
            when '${inputs.dimension.value}' = 'level' then 'L' || cast(management_level as varchar)
            when '${inputs.dimension.value}' = 'sub_team' then sub_team
            else squad
        end as group_label,
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
    select period_key, period_start, count(*) as total_hires
    from filtered
    group by 1, 2
),
overall_metric_by_month as (
    select
        period_key,
        period_start,
        case
            when '${inputs.metric.value}' = 'pct_30'
                then round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 2)
            else round(avg(days_to_first_pr), 2)
        end as overall_metric_value
    from filtered
    group by 1, 2
),
reference_by_group as (
    select
        group_label,
        count(*) as reference_hires,
        case
            when '${inputs.metric.value}' = 'pct_30'
                then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as reference_metric_value
    from filtered
    group by 1
),
selected_by_group as (
    select
        period_key,
        period_start,
        group_label,
        count(*) as selected_hires,
        case
            when '${inputs.metric.value}' = 'pct_30'
                then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as selected_metric_value
    from filtered
    group by 1, 2, 3
),
contributions as (
    select
        s.period_key,
        s.period_start,
        s.group_label,
        round(
            (((s.selected_hires * 1.0 / st.total_hires) - (r.reference_hires * 1.0 / rt.total_hires)) * r.reference_metric_value)
            + ((s.selected_hires * 1.0 / st.total_hires) * (s.selected_metric_value - r.reference_metric_value)),
            2
        ) as total_contribution
    from selected_by_group s
    join reference_by_group r using (group_label)
    join selected_totals st
      on s.period_key = st.period_key
     and s.period_start = st.period_start
    cross join reference_totals rt
),
ranked as (
    select
        *,
        max(abs(total_contribution)) over (partition by group_label) as max_abs_contribution
    from contributions
),
selected_cohort_groups as (
    select
        group_label,
        abs(total_contribution) as selected_cohort_abs_contribution
    from contributions
    where period_key = '${inputs.selected_period.value}'
)
select
    period_key,
    period_start,
    case
        when '${inputs.comparison_grain.value}' = 'half'
            then period_key
        else strftime(period_start, '%b %y')
    end as period_label,
    group_label,
    total_contribution,
    om.overall_metric_value
from ranked
join overall_metric_by_month om
  using (period_key, period_start)
where (
    '${inputs.group_visibility.value}' = 'all'
    or group_label in (
        select group_label
        from selected_cohort_groups
        qualify dense_rank() over (order by selected_cohort_abs_contribution desc, group_label) <= 5
    )
)
order by period_start, group_label
