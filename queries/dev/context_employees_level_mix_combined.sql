with level_order as (
    select
        'L' || cast(cast(latest_management_level as integer) as varchar) as level_label,
        cast(latest_management_level as integer) as level_order,
        count(*) as employees
    from productivity.dim_employees
    where latest_management_level is not null
    group by 1, 2
),
last_12 as (
    select
        'L' || cast(cast(latest_management_level as integer) as varchar) as level_label,
        count(*) as hires_12m
    from productivity.dim_employees
    where latest_management_level is not null
      and hire_date > (select max(hire_date) from productivity.dim_employees) - interval '12 months'
    group by 1
),
joined as (
    select
        o.level_label,
        o.level_order,
        o.employees,
        coalesce(h.hires_12m, 0) as hires_12m
    from level_order o
    left join last_12 h
        on o.level_label = h.level_label
)
select
    level_label,
    level_order,
    'Current employees' as metric,
    employees as value,
    employees,
    hires_12m
from joined

union all

select
    level_label,
    level_order,
    'New hires in last 12 months' as metric,
    hires_12m as value,
    employees,
    hires_12m
from joined

order by level_order, metric
