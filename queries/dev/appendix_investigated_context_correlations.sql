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
        s.office,
        s.days_to_first_pr,
        s.days_to_first_tier_3_pr,
        s.first_peer_velocity_match_ramp_month,
        s.squad_other_hires_within_30_days,
        sz.squad_active_employees
    from productivity.onboarding_summary s
    left join squad_sizes sz
      on sz.squad = s.squad
    where s.is_true_onboarding_metric = true
      and s.in_reliability_window = 1
      and s.role_productivity_category = 'Software Engineering'
      and s.employee_type = 'Permanent'
),
demeaned as (
    select
        wiser_id,
        office,
        days_to_first_pr - avg(days_to_first_pr) over (partition by office) as days_to_first_pr_dm,
        days_to_first_tier_3_pr - avg(days_to_first_tier_3_pr) over (partition by office) as days_to_first_tier_3_pr_dm,
        first_peer_velocity_match_ramp_month - avg(first_peer_velocity_match_ramp_month) over (partition by office) as parity_month_dm,
        squad_other_hires_within_30_days - avg(squad_other_hires_within_30_days) over (partition by office) as same_time_dm,
        squad_active_employees - avg(squad_active_employees) over (partition by office) as squad_size_dm
    from base
)
select
    round(corr(squad_size_dm, days_to_first_pr_dm), 3) as corr_squad_size_setup,
    round(corr(squad_size_dm, parity_month_dm), 3) as corr_squad_size_ramp,
    round(corr(same_time_dm, days_to_first_pr_dm), 3) as corr_same_time_setup,
    round(corr(same_time_dm, parity_month_dm), 3) as corr_same_time_ramp
from demeaned
