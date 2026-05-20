select
    role_productivity_category,
    count(*) as employees
from productivity.dim_employees
group by 1
order by employees desc, role_productivity_category
