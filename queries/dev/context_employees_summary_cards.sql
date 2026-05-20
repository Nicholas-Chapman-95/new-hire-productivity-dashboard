select
    count(*) as employees,
    count(*) filter (where is_active_latest = 1) as active_employees,
    count(distinct office) as offices,
    count(distinct sub_team) as sub_teams,
    count(distinct squad) as squads
from (
    select
        latest_office as office,
        latest_sub_team as sub_team,
        latest_squad as squad,
        is_active_latest
    from productivity.dim_employees
)
