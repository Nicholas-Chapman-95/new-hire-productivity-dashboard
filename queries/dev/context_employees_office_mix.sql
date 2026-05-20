select
    latest_office as office,
    count(*) as employees
from productivity.dim_employees
group by 1
order by employees desc, office
