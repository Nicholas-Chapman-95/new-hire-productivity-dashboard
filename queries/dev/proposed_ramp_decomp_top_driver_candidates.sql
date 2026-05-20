with benchmark as (
    select
        wiser_id,
        median(benchmark_pr_target) as benchmark_pr_target
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
    group by 1
),
hit as (
    select
        b.wiser_id,
        min(
            case
                when b.benchmark_pr_target > 0
                 and hp.employee_pr_rank >= b.benchmark_pr_target
                    then hp.days_since_hire_at_merge
            end
        ) as days_to_benchmark
    from benchmark b
    left join productivity.hire_pr_progression hp
        on b.wiser_id = hp.wiser_id
    group by 1
),
hire_windows as (
    select
        os.wiser_id,
        os.office,
        os.sub_team,
        os.squad,
        cast(os.management_level as integer) as management_level,
        max(case when erw.day_window = 0 and erw.is_window_fully_observed = 1 then erw.pr_count end) as prs_0_29,
        max(case when erw.day_window = 1 and erw.is_window_fully_observed = 1 then erw.pr_count end) as prs_30_59,
        max(case when erw.day_window = 2 and erw.is_window_fully_observed = 1 then erw.pr_count end) as prs_60_89,
        max(case when erw.day_window = 3 and erw.is_window_fully_observed = 1 then erw.pr_count end) as prs_90_119,
        max(case when erw.day_window = 4 and erw.is_window_fully_observed = 1 then erw.pr_count end) as prs_120_149,
        max(case when erw.day_window = 5 and erw.is_window_fully_observed = 1 then erw.pr_count end) as prs_150_179
    from productivity.onboarding_summary os
    left join productivity.exact_ramp_windows erw
        on os.wiser_id = erw.wiser_id
    where os.role_productivity_category = 'Software Engineering'
      and os.employee_type = 'Permanent'
      and os.is_true_onboarding_metric = true
      and os.in_reliability_window = 1
    group by 1, 2, 3, 4, 5
),
hire_level as (
    select
        hw.*,
        h.days_to_benchmark
    from hire_windows hw
    left join hit h
        on hw.wiser_id = h.wiser_id
),
all_groups as (
    select 'office' as dimension, 'Office' as dimension_label, office as group_label, null::integer as sort_key, *
    from hire_level
    where office is not null

    union all

    select 'level' as dimension, 'Level' as dimension_label, 'L' || cast(management_level as varchar) as group_label, management_level as sort_key, *
    from hire_level
    where management_level is not null

    union all

    select 'sub_team' as dimension, 'Sub-Team' as dimension_label, sub_team as group_label, null::integer as sort_key, *
    from hire_level
    where sub_team is not null

    union all

    select 'squad' as dimension, 'Squad' as dimension_label, squad as group_label, null::integer as sort_key, *
    from hire_level
    where squad is not null
),
grouped as (
    select
        dimension,
        dimension_label,
        group_label,
        min(sort_key) as sort_key,
        count(*) as hires,
        round(median(prs_0_29), 1) as median_prs_0_29,
        round(median(prs_30_59), 1) as median_prs_30_59,
        round(median(prs_60_89), 1) as median_prs_60_89,
        round(median(prs_90_119), 1) as median_prs_90_119,
        round(median(prs_120_149), 1) as median_prs_120_149,
        round(median(prs_150_179), 1) as median_prs_150_179,
        round(median(days_to_benchmark), 1) as median_days_to_benchmark,
        round(avg(case when days_to_benchmark <= 60 then 1.0 else 0.0 end) * 100, 1) as benchmark_by_day_60,
        round(avg(case when days_to_benchmark <= 90 then 1.0 else 0.0 end) * 100, 1) as benchmark_by_day_90
    from all_groups
    group by 1, 2, 3
    having count(*) >= 3
),
ranked as (
    select
        *,
        dense_rank() over (order by median_prs_30_59 asc nulls last) as pace_rank_30_59,
        dense_rank() over (order by median_prs_60_89 asc nulls last) as pace_rank_60_89,
        dense_rank() over (order by benchmark_by_day_90 asc nulls last) as benchmark_rank_90
    from grouped
),
scored as (
    select
        *,
        pace_rank_30_59 + pace_rank_60_89 + benchmark_rank_90 as combined_driver_rank,
        case
            when pace_rank_30_59 <= 3 and pace_rank_60_89 <= 3 and benchmark_rank_90 <= 3
                then 'Weak early, weak later, and below benchmark'
            when pace_rank_30_59 <= 3 and pace_rank_60_89 <= 3
                then 'Weak pace across early and mid ramp'
            when pace_rank_30_59 <= 3 and benchmark_rank_90 <= 3
                then 'Weak early pace and below benchmark'
            when pace_rank_60_89 <= 3 and benchmark_rank_90 <= 3
                then 'Weak later pace and below benchmark'
            when pace_rank_30_59 <= 3
                then 'Weak mainly in early ramp'
            when pace_rank_60_89 <= 3
                then 'Weak mainly in mid ramp'
            when benchmark_rank_90 <= 3
                then 'Below benchmark by day 90'
            else 'Secondary'
        end as driver_signal
    from ranked
)
select
    row_number() over (
        order by combined_driver_rank, benchmark_by_day_90, median_prs_60_89, median_prs_30_59, dimension, sort_key, group_label
    ) as driver_rank,
    dimension,
    dimension_label,
    group_label,
    dimension_label || ': ' || group_label as factor_label,
    hires,
    median_prs_0_29,
    median_prs_30_59,
    median_prs_60_89,
    median_prs_90_119,
    median_prs_120_149,
    median_prs_150_179,
    median_days_to_benchmark,
    benchmark_by_day_60,
    benchmark_by_day_90,
    pace_rank_30_59,
    pace_rank_60_89,
    benchmark_rank_90,
    combined_driver_rank,
    driver_signal
from scored
order by combined_driver_rank, benchmark_by_day_90, median_prs_60_89, median_prs_30_59, dimension, sort_key, group_label
