with filtered as (
    select
        office,
        sub_team,
        squad,
        'L' || cast(cast(management_level as integer) as varchar) as level_label,
        cast(management_level as integer) as management_level,
        days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and days_to_first_pr is not null
      and cohort_month between '2025-03' and '2026-02'
),
all_groups as (
    select 'squad' as dimension, 'Squad' as dimension_label, squad as group_label, null::integer as sort_key, days_to_first_pr
    from filtered
    where squad is not null

    union all

    select 'sub_team' as dimension, 'Sub-Team' as dimension_label, sub_team as group_label, null::integer as sort_key, days_to_first_pr
    from filtered
    where sub_team is not null

    union all

    select 'office' as dimension, 'Office' as dimension_label, office as group_label, null::integer as sort_key, days_to_first_pr
    from filtered
    where office is not null

    union all

    select 'level' as dimension, 'Level' as dimension_label, level_label as group_label, management_level as sort_key, days_to_first_pr
    from filtered
    where management_level is not null
)
select
    dimension,
    dimension_label,
    group_label,
    min(sort_key) as sort_key,
    count(*) as hires,
    round(avg(days_to_first_pr), 1) as mean_days_to_first_pr,
    round(median(days_to_first_pr), 1) as median_days_to_first_pr,
    round(avg(case when days_to_first_pr <= 30 then 1.0 else 0.0 end) * 100, 1) as pct_within_30_days
from all_groups
group by 1, 2, 3
having count(*) >= 3
order by mean_days_to_first_pr desc, dimension, sort_key, group_label
