with filtered as (
    select
        cohort_month,
        cast(cohort_month || '-01' as date) as cohort_date,
        strftime(cast(cohort_month || '-01' as date), '%b %y') as cohort_label,
        office as group_label,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and cohort_month >= '2025-03'
),
reference_totals as (
    select count(*) as total_hires
    from filtered
),
reference_by_group as (
    select
        group_label,
        count(*) as reference_hires,
        avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100 as reference_metric_value
    from filtered
    group by 1
),
selected_totals as (
    select cohort_month, count(*) as total_hires
    from filtered
    group by 1
),
selected_by_group as (
    select
        cohort_month,
        cohort_date,
        group_label,
        count(*) as selected_hires,
        avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100 as selected_metric_value
    from filtered
    group by 1, 2, 3
),
all_months as (
    select distinct cohort_month, cohort_date from filtered
),
offices as (
    select distinct group_label from reference_by_group
),
grid as (
    select
        m.cohort_month,
        m.cohort_date,
        strftime(m.cohort_date, '%b %y') as cohort_label,
        o.group_label
    from all_months m
    cross join offices o
)
select
    g.cohort_month,
    g.cohort_date,
    g.cohort_label,
    g.group_label,
    round(
        (
            ((coalesce(s.selected_hires, 0) * 1.0 / st.total_hires) - (coalesce(r.reference_hires, 0) * 1.0 / rt.total_hires))
            * r.reference_metric_value
        ) + (
            (coalesce(s.selected_hires, 0) * 1.0 / st.total_hires)
            * (coalesce(s.selected_metric_value, r.reference_metric_value) - r.reference_metric_value)
        ),
        2
    ) as total_contribution
from grid g
left join selected_by_group s
    on g.cohort_month = s.cohort_month
   and g.group_label = s.group_label
left join reference_by_group r
    on g.group_label = r.group_label
left join selected_totals st
    on g.cohort_month = st.cohort_month
cross join reference_totals rt
where st.total_hires > 0
order by g.cohort_date, g.group_label
