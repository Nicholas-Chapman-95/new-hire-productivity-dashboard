with grouped as (
    select
        case
            when '${inputs.breakdown_by.value}' = 'office' then os.office
            when '${inputs.breakdown_by.value}' = 'level' then 'L' || cast(cast(os.management_level as integer) as varchar)
            when '${inputs.breakdown_by.value}' = 'sub_team' then os.sub_team
            else os.squad
        end as group_label,
        case
            when '${inputs.breakdown_by.value}' = 'level' then cast(os.management_level as integer)
            else null
        end as sort_key,
        count(distinct os.wiser_id) as hires,
        erw.day_window,
        erw.day_window_label,
        round(median(erw.pr_count), 1) as median_pr_count,
        round(median(erw.pct_of_contemporaneous_benchmark) * 100, 1) as median_pct_of_benchmark,
        round(avg(case when erw.has_hit_local_benchmark = 1 then 1.0 else 0.0 end) * 100, 1) as hit_local_benchmark_rate
    from productivity.onboarding_summary os
    join productivity.exact_ramp_windows erw
        on os.wiser_id = erw.wiser_id
    where os.role_productivity_category = 'Software Engineering'
      and os.employee_type = 'Permanent'
      and os.is_true_onboarding_metric = true
      and os.in_reliability_window = 1
      and erw.is_window_fully_observed = 1
      and case
            when '${inputs.breakdown_by.value}' = 'office' then os.office
            when '${inputs.breakdown_by.value}' = 'level' then cast(os.management_level as varchar)
            when '${inputs.breakdown_by.value}' = 'sub_team' then os.sub_team
            else os.squad
          end is not null
    group by 1, 2, 4, 5
),
top_groups as (
    select
        group_label,
        min(sort_key) as sort_key,
        max(hires) as hires
    from grouped
    group by 1
    qualify row_number() over (
        order by
            case when min(sort_key) is null then max(hires) end desc,
            min(sort_key),
            group_label
    ) <= 5
)
select
    g.group_label,
    g.sort_key,
    g.hires,
    g.day_window,
    g.day_window_label,
    g.median_pr_count,
    g.median_pct_of_benchmark,
    g.hit_local_benchmark_rate
from grouped g
join top_groups tg
    on g.group_label = tg.group_label
order by
    g.day_window,
    case when g.sort_key is null then g.hires end desc,
    g.sort_key,
    g.group_label
