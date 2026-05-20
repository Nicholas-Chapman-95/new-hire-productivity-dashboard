with onboarding as (
    select
        wiser_id,
        office,
        sub_team,
        hire_date,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category like '${inputs.role_productivity_category.value}'
      and employee_type like '${inputs.employee_type.value}'
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
      and days_to_first_pr is not null
      and cohort_month >= '2025-03'
),
office_setup as (
    select
        'Office' as grain,
        office as group_name,
        count(*) as hires,
        round(median(days_to_first_pr), 1) as median_days_to_first_pr,
        round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_within_30_days
    from onboarding
    group by 1, 2
),
office_gaps as (
    select
        office as group_name,
        round(avg(gap_days), 1) as avg_gap_days
    from (
        select
            office,
            date_diff('day', lag(hire_date) over (partition by office order by hire_date), hire_date) as gap_days
        from onboarding
    )
    where gap_days is not null
    group by 1
),
sub_setup as (
    select
        'Sub-Team' as grain,
        sub_team as group_name,
        count(*) as hires,
        round(median(days_to_first_pr), 1) as median_days_to_first_pr,
        round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_within_30_days
    from onboarding
    group by 1, 2
),
sub_gaps as (
    select
        sub_team as group_name,
        round(avg(gap_days), 1) as avg_gap_days
    from (
        select
            sub_team,
            date_diff('day', lag(hire_date) over (partition by sub_team order by hire_date), hire_date) as gap_days
        from onboarding
    )
    where gap_days is not null
    group by 1
)
select
    s.grain,
    s.group_name,
    s.hires,
    g.avg_gap_days,
    s.median_days_to_first_pr,
    s.pct_within_30_days
from office_setup s
left join office_gaps g using (group_name)
where s.hires >= 3
union all
select
    s.grain,
    s.group_name,
    s.hires,
    g.avg_gap_days,
    s.median_days_to_first_pr,
    s.pct_within_30_days
from sub_setup s
left join sub_gaps g using (group_name)
where s.hires >= 3
order by grain, hires desc, group_name
