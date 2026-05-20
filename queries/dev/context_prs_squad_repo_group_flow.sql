with base as (
    select
        attributed_employee_squad as squad,
        split_part(pr_repository_name, '-', 1) as repo_group,
        count(*) as prs
    from productivity.pull_requests
    where pr_repository_name is not null
      and attributed_employee_squad is not null
      and attributed_employee_type = 'Permanent'
      and attributed_employee_job_family = 'Engineering'
    group by 1, 2
),
top_squads as (
    select squad
    from (
        select squad, sum(prs) as total_prs
        from base
        group by 1
        order by total_prs desc, squad
        limit 6
    )
),
top_repo_groups as (
    select repo_group
    from (
        select repo_group, sum(prs) as total_prs
        from base
        group by 1
        order by total_prs desc, repo_group
        limit 8
    )
)
select
    squad as source,
    repo_group as target,
    prs as value
from base
where squad in (select squad from top_squads)
  and repo_group in (select repo_group from top_repo_groups)
order by value desc, source, target
