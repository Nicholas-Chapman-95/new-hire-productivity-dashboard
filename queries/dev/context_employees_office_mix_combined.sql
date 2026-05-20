with office_order as (
    select
        latest_office as office,
        count(*) as employees
    from productivity.dim_employees
    where latest_office is not null
    group by 1
),
last_12 as (
    select
        latest_office as office,
        count(*) as hires_12m
    from productivity.dim_employees
    where latest_office is not null
      and hire_date > (select max(hire_date) from productivity.dim_employees) - interval '12 months'
    group by 1
),
joined as (
    select
        o.office,
        o.employees,
        coalesce(h.hires_12m, 0) as hires_12m
    from office_order o
    left join last_12 h
        on o.office = h.office
)
select
    office,
    'Current employees' as metric,
    employees as value,
    employees,
    hires_12m
from joined

union all

select
    office,
    'New hires in last 12 months' as metric,
    hires_12m as value,
    employees,
    hires_12m
from joined

order by employees desc, office, metric
