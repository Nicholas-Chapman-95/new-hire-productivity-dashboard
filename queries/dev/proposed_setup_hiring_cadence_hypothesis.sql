with onboarding as (
    select
        wiser_id,
        case
            when '${inputs.cadence_context.value}' = 'office' then office
            else squad
        end as group_name,
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
setup as (
    select
        group_name,
        count(*) as hires,
        round(median(days_to_first_pr), 1) as median_days_to_first_pr,
        round(avg(days_to_first_pr), 1) as average_days_to_first_pr,
        round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_within_30_days
    from onboarding
    group by 1
),
gaps as (
    select
        group_name,
        round(avg(gap_days), 1) as avg_gap_days,
        round(median(gap_days), 1) as median_gap_days
    from (
        select
            group_name,
            date_diff('day', lag(hire_date) over (partition by group_name order by hire_date), hire_date) as gap_days
        from onboarding
    )
    where gap_days is not null
    group by 1
),
bursts as (
    select
        group_name,
        round(avg(within_30), 1) as avg_other_hires_within_30_days
    from (
        select
            o1.group_name,
            o1.wiser_id,
            sum(
                case
                    when o2.wiser_id != o1.wiser_id
                     and abs(date_diff('day', o1.hire_date, o2.hire_date)) <= 30
                        then 1
                    else 0
                end
            ) as within_30
        from onboarding o1
        join onboarding o2
          on o1.group_name = o2.group_name
        group by 1, 2
    )
    group by 1
),
sizes as (
    select
        case
            when '${inputs.cadence_context.value}' = 'office' then latest_office
            else latest_squad
        end as group_name,
        count(*) filter (
            where role_productivity_category = 'Software Engineering'
              and is_active_latest = 1
        ) as eng_current_employees
    from productivity.dim_employees
    group by 1
)
select
    s.group_name,
    s.hires,
    s.median_days_to_first_pr,
    s.average_days_to_first_pr,
    s.pct_within_30_days,
    coalesce(sz.eng_current_employees, 0) as eng_current_employees,
    g.avg_gap_days,
    g.median_gap_days,
    coalesce(b.avg_other_hires_within_30_days, 0) as avg_other_hires_within_30_days
from setup s
left join gaps g using (group_name)
left join bursts b using (group_name)
left join sizes sz using (group_name)
where s.hires >= 3
order by s.hires desc, s.group_name
