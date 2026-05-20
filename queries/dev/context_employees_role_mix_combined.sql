with role_order as (
    select
        role_productivity_category,
        count(*) as employees
    from productivity.dim_employees
    where role_productivity_category is not null
    group by 1
),
last_12 as (
    select
        role_productivity_category,
        count(*) as hires_12m
    from productivity.dim_employees
    where role_productivity_category is not null
      and hire_date > (select max(hire_date) from productivity.dim_employees) - interval '12 months'
    group by 1
),
joined as (
    select
        o.role_productivity_category,
        o.employees,
        coalesce(h.hires_12m, 0) as hires_12m
    from role_order o
    left join last_12 h
        on o.role_productivity_category = h.role_productivity_category
)
select
    role_productivity_category,
    'Current employees' as metric,
    employees as value,
    employees,
    hires_12m
from joined

union all

select
    role_productivity_category,
    'New hires in last 12 months' as metric,
    hires_12m as value,
    employees,
    hires_12m
from joined

order by employees desc, role_productivity_category, metric
