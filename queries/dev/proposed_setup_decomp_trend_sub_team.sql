with filtered as (
    select cohort_month, sub_team as group_label, days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
      and sub_team is not null
),
reference_total as (
    select count(*) as total_hires from filtered
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
        cohort_month,
        group_label,
        count(*) as selected_hires,
        case
            when '${inputs.metric.value}' = 'pct_30' then avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100
            else avg(days_to_first_pr)
        end as selected_metric_value
    from filtered
    group by 1, 2
),
selected_totals as (
    select cohort_month, count(*) as total_hires
    from filtered
    group by 1
),
contributions as (
    select
        s.cohort_month,
        s.group_label,
        round(
            (((s.selected_hires * 1.0 / st.total_hires) - (r.reference_hires * 1.0 / rt.total_hires)) * r.reference_metric_value)
            + ((s.selected_hires * 1.0 / st.total_hires) * (s.selected_metric_value - r.reference_metric_value)),
            2
        ) as total_contribution
    from selected_by_group s
    join reference_by_group r using (group_label)
    join selected_totals st using (cohort_month)
    cross join reference_total rt
),
ranked as (
    select
        *,
        max(abs(total_contribution)) over (partition by group_label) as max_abs_contribution
    from contributions
)
select cast(cohort_month || '-01' as date) as cohort_date, cohort_month, group_label, total_contribution
from ranked
qualify dense_rank() over (order by max_abs_contribution desc, group_label) <= 5
order by cohort_month, group_label
