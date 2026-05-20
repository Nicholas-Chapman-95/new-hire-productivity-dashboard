with base as (
    select
        os.cohort_month,
        date_trunc(
            'month',
            cast(os.hire_date as date) + cast(hp.days_since_hire_at_merge as integer) * interval '1 day'
        )::date as report_month,
        count(*) as prs
    from productivity.onboarding_summary os
    join productivity.hire_pr_progression hp
        on os.wiser_id = hp.wiser_id
    where os.role_productivity_category = 'Software Engineering'
      and os.employee_type = 'Permanent'
      and os.is_true_onboarding_metric = true
      and os.in_reliability_window = 1
    group by 1, 2
),
cohort_sizes as (
    select
        cohort_month,
        count(*) as hires
    from productivity.onboarding_summary
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
    group by 1
),
ranked as (
    select
        b.cohort_month,
        cs.hires,
        b.report_month,
        b.prs,
        sum(b.prs) over (
            partition by b.cohort_month
            order by b.report_month
            rows between unbounded preceding and current row
        ) as cumulative_prs
    from base b
    join cohort_sizes cs
        on b.cohort_month = cs.cohort_month
    where cs.hires >= 4
)
select
    cohort_month,
    hires,
    report_month,
    strftime(report_month, '%Y-%m') as report_month_label,
    strftime(report_month, '%b %y') as report_month_short,
    prs,
    cumulative_prs
from ranked
order by report_month, cohort_month
