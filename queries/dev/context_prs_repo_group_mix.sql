select
    split_part(pr_repository_name, '-', 1) as repo_group,
    count(*) as prs
from productivity.pull_requests
where pr_repository_name is not null
group by 1
order by prs desc, repo_group
