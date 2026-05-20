with base as (
    select
        case
            when '${inputs.compare_dimension.value}' = 'cross_office_squad_status' then cross_office_squad_status
            else office
        end as group_label,
        case
            when cohort_month between '2025-03' and '2025-08' then '2025-03 to 2025-08'
            when cohort_month between '2025-09' and '2026-02' then '2025-09 to 2026-02'
        end as period,
        case
            when '${inputs.day_basis.value}' = 'business' then business_days_to_first_pr
            else days_to_first_pr
        end as selected_days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and cohort_month between '2025-03' and '2026-02'
)
select
    group_label,
    period,
    count(*) as hires,
    round(avg(selected_days_to_first_pr), 1) as mean_days_to_first_pr
from base
where group_label is not null
  and selected_days_to_first_pr is not null
group by 1, 2
order by group_label, period
