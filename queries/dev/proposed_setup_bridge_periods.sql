with filtered as (
    select
        cast(cohort_month || '-01' as date) as cohort_date
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
),
periodized as (
    select
        case
            when '${inputs.bridge_comparison_grain.value}' = 'half'
                then cast(extract(year from cohort_date) as varchar) || ' H' ||
                    case when extract(month from cohort_date) <= 6 then '1' else '2' end
            else strftime(cohort_date, '%Y-%m')
        end as value,
        case
            when '${inputs.bridge_comparison_grain.value}' = 'half'
                then make_date(
                    cast(extract(year from cohort_date) as integer),
                    case when extract(month from cohort_date) <= 6 then 1 else 7 end,
                    1
                )
            else cohort_date
        end as period_start
    from filtered
),
counts as (
    select
        value,
        period_start,
        count(*) as hires
    from periodized
    group by 1, 2
)
select
    value,
    value || ' (' || cast(hires as varchar) || ')' as label,
    period_start,
    hires
from counts
order by period_start
