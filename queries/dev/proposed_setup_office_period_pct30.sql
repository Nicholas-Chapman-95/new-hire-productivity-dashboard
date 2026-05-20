with base as (
    select
        office as group_label,
        case
            when cohort_month between '2025-03' and '2025-08' then '2025-03 to 2025-08'
            when cohort_month between '2025-09' and '2026-02' then '2025-09 to 2026-02'
        end as period,
        days_since_hire,
        days_to_first_pr
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
    sum(case when days_since_hire >= 30 then 1 else 0 end) as observed_30d_hires,
    round(
        avg(
            case
                when days_since_hire >= 30 and days_to_first_pr <= 30 then 1.0
                when days_since_hire >= 30 then 0.0
            end
        ) * 100,
        1
    ) as pct_within_30_days
from base
where group_label is not null
  and days_to_first_pr is not null
group by 1, 2
order by group_label, period
