select
    pr_repository_name,
    count(*) as prs
from productivity.pull_requests
where pr_repository_name is not null
group by 1
order by prs desc, pr_repository_name
limit 15
