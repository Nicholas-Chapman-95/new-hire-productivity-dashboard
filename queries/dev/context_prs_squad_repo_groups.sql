with base as (
    select
        attributed_employee_squad as squad,
        split_part(pr_repository_name, '-', 1) as repo_group,
        count(*) as prs
    from productivity.pull_requests
    where pr_repository_name is not null
      and attributed_employee_squad is not null
    group by 1, 2
),
ranked as (
    select
        squad,
        repo_group,
        prs,
        row_number() over (partition by squad order by prs desc, repo_group) as rn
    from base
)
select
    squad,
    repo_group,
    prs
from ranked
where rn <= 3
order by squad, rn
