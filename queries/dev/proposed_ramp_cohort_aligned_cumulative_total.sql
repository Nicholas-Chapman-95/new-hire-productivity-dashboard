with base as (
    select
        os.cohort_month,
        date_trunc('month', cast(os.hire_date as date))::date as cohort_start_month,
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
    group by 1, 2, 3
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
        date_diff('month', b.cohort_start_month, b.report_month) as cohort_age_month,
        'M+' || cast(date_diff('month', b.cohort_start_month, b.report_month) as varchar) as cohort_age_label,
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
    cohort_age_month,
    cohort_age_label,
    report_month,
    prs,
    cumulative_prs
from ranked
order by cohort_age_month, cohort_month
