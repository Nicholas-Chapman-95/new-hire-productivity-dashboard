select
    'L' || cast(cast(latest_management_level as integer) as varchar) as level_label,
    cast(latest_management_level as integer) as level_order,
    count(*) as employees
from productivity.dim_employees
where latest_management_level is not null
group by 1, 2
order by level_order
