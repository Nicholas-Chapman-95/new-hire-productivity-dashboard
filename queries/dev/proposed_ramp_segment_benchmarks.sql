with office_benchmark as (
    select
        'Office' as segment_type,
        office as segment,
        median(benchmark_pr_target) as benchmark_pr_target,
        count(distinct wiser_id) as hires
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
      and office is not null
    group by 1, 2
),
level_benchmark as (
    select
        'Level' as segment_type,
        'L' || cast(management_level as varchar) as segment,
        median(benchmark_pr_target) as benchmark_pr_target,
        count(distinct wiser_id) as hires
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
      and management_level is not null
    group by 1, 2
),
squad_benchmark as (
    select
        'Squad' as segment_type,
        squad as segment,
        median(benchmark_pr_target) as benchmark_pr_target,
        count(distinct wiser_id) as hires
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
      and squad is not null
    group by 1, 2
    having count(distinct wiser_id) >= 4
),
segments as (
    select * from office_benchmark
    union all
    select * from level_benchmark
    union all
    select * from squad_benchmark
),
hire_segment_days as (
    select
        'Office' as segment_type,
        office as segment,
        wiser_id,
        median(benchmark_pr_target) as benchmark_pr_target
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
      and office is not null
    group by 1, 2, 3

    union all

    select
        'Level' as segment_type,
        'L' || cast(management_level as varchar) as segment,
        wiser_id,
        median(benchmark_pr_target) as benchmark_pr_target
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
      and management_level is not null
    group by 1, 2, 3

    union all

    select
        'Squad' as segment_type,
        squad as segment,
        wiser_id,
        median(benchmark_pr_target) as benchmark_pr_target
    from productivity.exact_ramp_windows
    where role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and is_true_onboarding_metric = true
      and in_reliability_window = 1
      and squad is not null
    group by 1, 2, 3
),
hit as (
    select
        hs.segment_type,
        hs.segment,
        hs.wiser_id,
        min(
            case
                when hs.benchmark_pr_target > 0
                 and hp.employee_pr_rank >= hs.benchmark_pr_target
                    then hp.days_since_hire_at_merge
            end
        ) as days_to_benchmark
    from hire_segment_days hs
    left join productivity.hire_pr_progression hp
        on hs.wiser_id = hp.wiser_id
    group by 1, 2, 3
)
select
    s.segment_type,
    s.segment,
    s.benchmark_pr_target,
    s.hires,
    median(h.days_to_benchmark) as median_days_to_benchmark,
    avg(case when h.days_to_benchmark <= 60 then 1.0 else 0.0 end) as benchmark_by_day_60,
    avg(case when h.days_to_benchmark <= 90 then 1.0 else 0.0 end) as benchmark_by_day_90
from segments s
left join hit h
    on s.segment_type = h.segment_type
   and s.segment = h.segment
group by 1, 2, 3, 4
order by s.benchmark_pr_target desc, s.hires desc, s.segment_type, s.segment
