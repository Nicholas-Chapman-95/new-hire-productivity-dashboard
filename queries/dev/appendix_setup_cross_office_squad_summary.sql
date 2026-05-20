with hires as (
    select
        wiser_id,
        squad,
        office,
        days_to_first_pr,
        days_since_hire
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and squad is not null
),
squad_offices as (
    select
        squad,
        count(distinct office) as office_count
    from hires
    where office is not null
    group by 1
),
labeled as (
    select
        h.*,
        case
            when so.office_count >= 2 then 'Cross-office squad'
            else 'Single-office squad'
        end as squad_type
    from hires h
    join squad_offices so using (squad)
)
select
    squad_type,
    count(*) as hires,
    sum(case when days_since_hire >= 30 then 1 else 0 end) as observed_30d_hires,
    round(
        avg(
            case
                when days_since_hire >= 30 and days_to_first_pr <= 30 then 1.0
                when days_since_hire >= 30 then 0.0
            end
        ) * 100,
        1
    ) as pct_by_day_30,
    round(median(days_to_first_pr), 1) as median_days_to_first_pr,
    round(avg(days_to_first_pr), 1) as mean_days_to_first_pr
from labeled
group by 1
order by squad_type
