with group_totals as (
    select
        split_part(pr_repository_name, '-', 1) as repo_group,
        count(*) as prs
    from productivity.pull_requests
    where pr_repository_name is not null
    group by 1
),
top_groups as (
    select repo_group
    from group_totals
    order by prs desc, repo_group
    limit 5
)
select
    pr_merged_month as report_month,
    split_part(pr_repository_name, '-', 1) as repo_group,
    count(*) as prs
from productivity.pull_requests
where pr_repository_name is not null
  and split_part(pr_repository_name, '-', 1) in (select repo_group from top_groups)
group by 1, 2
order by 1, 2
