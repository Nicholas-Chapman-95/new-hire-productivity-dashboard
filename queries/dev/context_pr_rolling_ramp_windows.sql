with prs as (
    select
        os.wiser_id,
        os.days_since_hire,
        date_diff('day', os.hire_date, p.pr_merged_date) as days_since_hire_at_pr
    from productivity.onboarding_summary os
    inner join productivity.pull_requests p
        on os.wiser_id = p.attributed_employee_wiser_id
    where os.is_true_onboarding_metric = true
        and os.role_productivity_category = 'Software Engineering'
        and os.employee_type = 'Permanent'
        and p.pr_merged_before_created = 0
        and p.pr_merged_date >= os.hire_date
),
counts as (
    select
        wiser_id,
        count(case when days_since_hire_at_pr between 0 and 29 then 1 end) as first_30,
        count(case when days_since_hire_at_pr between 30 and 59 then 1 end) as second_30,
        count(case when days_since_hire_at_pr between 60 and 89 then 1 end) as third_30
    from prs
    group by 1
),
eligible as (
    select
        os.wiser_id,
        os.days_since_hire,
        coalesce(c.first_30, 0) as first_30,
        coalesce(c.second_30, 0) as second_30,
        coalesce(c.third_30, 0) as third_30
    from productivity.onboarding_summary os
    left join counts c
        on os.wiser_id = c.wiser_id
    where os.is_true_onboarding_metric = true
        and os.role_productivity_category = 'Software Engineering'
        and os.employee_type = 'Permanent'
)
select
    'First 30 days' as ramp_window,
    count(*) filter (where days_since_hire >= 30) as eligible_hires,
    median(first_30) filter (where days_since_hire >= 30) as median_prs,
    avg(first_30) filter (where days_since_hire >= 30) as avg_prs
from eligible

union all

select
    'Days 30-59' as ramp_window,
    count(*) filter (where days_since_hire >= 60) as eligible_hires,
    median(second_30) filter (where days_since_hire >= 60) as median_prs,
    avg(second_30) filter (where days_since_hire >= 60) as avg_prs
from eligible

union all

select
    'Days 60-89' as ramp_window,
    count(*) filter (where days_since_hire >= 90) as eligible_hires,
    median(third_30) filter (where days_since_hire >= 90) as median_prs,
    avg(third_30) filter (where days_since_hire >= 90) as avg_prs
from eligible
