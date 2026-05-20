select
    latest_squad as squad,
    count(*) as employees
from productivity.dim_employees
where latest_squad is not null
group by 1
order by employees desc, squad
limit 10
