with prs as (
    select
        os.wiser_id,
        os.squad,
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
        squad,
        count(case when days_since_hire_at_pr between 0 and 29 then 1 end) as first_30,
        count(case when days_since_hire_at_pr between 30 and 59 then 1 end) as second_30,
        count(case when days_since_hire_at_pr between 60 and 89 then 1 end) as third_30
    from prs
    group by 1, 2
),
eligible as (
    select
        os.wiser_id,
        os.squad,
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
    squad,
    count(*) filter (where days_since_hire >= 30) as hires_30d,
    median(first_30) filter (where days_since_hire >= 30) as median_first_30_days_prs,
    count(*) filter (where days_since_hire >= 60) as hires_60d,
    median(second_30) filter (where days_since_hire >= 60) as median_second_30_days_prs,
    count(*) filter (where days_since_hire >= 90) as hires_90d,
    median(third_30) filter (where days_since_hire >= 90) as median_third_30_days_prs
from eligible
group by 1
order by hires_30d desc, squad
