select
    latest_office as office,
    case
        when is_engineering_role_latest = 1 then 'Engineering'
        else 'Non-Engineering'
    end as population,
    count(*) as employees
from productivity.dim_employees
group by 1, 2
order by office, population
