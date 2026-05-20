with base as (
    with squad_sizes as (
        select
            latest_squad as squad,
            count(*) filter (where role_productivity_category = 'Software Engineering' and is_active_latest = 1) as squad_active_employees
        from productivity.dim_employees
        where latest_squad is not null
        group by 1
    )
    select
        s.wiser_id,
        s.days_to_first_pr,
        s.days_to_first_tier_3_pr,
        case when s.days_to_first_pr <= 30 then 1 else 0 end as hit_30,
        sz.squad_active_employees,
        max(case when r.day_window = 2 and r.is_window_fully_observed = 1 then r.has_hit_local_benchmark end) as hit_benchmark_60_89
    from productivity.onboarding_summary s
    left join squad_sizes sz
      on sz.squad = s.squad
    left join productivity.exact_ramp_windows r
      on r.wiser_id = s.wiser_id
     and r.is_true_onboarding_metric = true
     and r.in_reliability_window = 1
     and r.role_productivity_category = 'Software Engineering'
     and r.employee_type = 'Permanent'
    where s.is_true_onboarding_metric = true
      and s.in_reliability_window = 1
      and s.role_productivity_category = 'Software Engineering'
      and s.employee_type = 'Permanent'
      and sz.squad_active_employees is not null
    group by 1, 2, 3, 4, 5
),
buckets as (
    select
        case
            when squad_active_employees <= 4 then '<=4'
            when squad_active_employees between 5 and 7 then '5-7'
            when squad_active_employees between 8 and 10 then '8-10'
            else '11+'
        end as bucket_label,
        case
            when squad_active_employees <= 4 then 1
            when squad_active_employees between 5 and 7 then 2
            when squad_active_employees between 8 and 10 then 3
            else 4
        end as bucket_order,
        wiser_id,
        days_to_first_pr,
        days_to_first_tier_3_pr,
        hit_30,
        hit_benchmark_60_89
    from base
)
select
    bucket_label,
    bucket_order,
    count(*) as hires,
    round(median(days_to_first_pr), 1) as median_days_to_first_pr,
    round(avg(hit_30) * 100, 1) as pct_within_30_days,
    round(median(days_to_first_tier_3_pr), 1) as median_days_to_first_tier_3_pr,
    round(avg(hit_benchmark_60_89) * 100, 1) as pct_hit_benchmark_60_89
from buckets
group by 1, 2
order by bucket_order
