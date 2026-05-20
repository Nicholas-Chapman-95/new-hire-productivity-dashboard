with squad_order as (
    select
        latest_squad as squad,
        count(*) as employees
    from productivity.dim_employees
    where latest_squad is not null
    group by 1
),
last_12 as (
    select
        squad,
        count(*) as hires_12m
    from productivity.onboarding_summary
    where hire_date > (select max(hire_date) from productivity.onboarding_summary) - interval '12 months'
      and squad is not null
    group by 1
)
select
    o.squad,
    o.employees,
    hires_12m
from squad_order o
left join last_12 h
    on o.squad = h.squad
order by o.employees desc, o.squad
