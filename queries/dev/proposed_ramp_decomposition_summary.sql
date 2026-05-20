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
        os.management_level,
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
grouped as (
    select
        case
            when '${inputs.breakdown_by.value}' = 'office' then office
            when '${inputs.breakdown_by.value}' = 'level' then 'L' || cast(cast(management_level as integer) as varchar)
            when '${inputs.breakdown_by.value}' = 'sub_team' then sub_team
            else squad
        end as group_label,
        case
            when '${inputs.breakdown_by.value}' = 'level' then cast(management_level as integer)
            else null
        end as sort_key,
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
    from hire_level
    where case
            when '${inputs.breakdown_by.value}' = 'office' then office
            when '${inputs.breakdown_by.value}' = 'level' then cast(management_level as varchar)
            when '${inputs.breakdown_by.value}' = 'sub_team' then sub_team
            else squad
          end is not null
    group by 1, 2
    having count(*) >= 3
),
ranked as (
    select
        *,
        dense_rank() over (order by median_prs_30_59 asc nulls last) as pace_rank_30_59,
        dense_rank() over (order by benchmark_by_day_90 asc nulls last) as benchmark_rank_90
    from grouped
)
select *
    ,
    pace_rank_30_59 + benchmark_rank_90 as combined_driver_rank,
    case
        when pace_rank_30_59 <= 2 and benchmark_rank_90 <= 2
            then 'Weak on both pace and benchmark'
        when pace_rank_30_59 <= 2
            then 'Weak mainly on raw pace'
        when benchmark_rank_90 <= 2
            then 'Weak mainly on benchmark attainment'
        else 'Less urgent'
    end as driver_signal
from ranked
order by
    combined_driver_rank,
    benchmark_by_day_90,
    median_prs_30_59,
    case when sort_key is null then hires end desc,
    sort_key,
    group_label
