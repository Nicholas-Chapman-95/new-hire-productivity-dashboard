with base as (
    select *
    from productivity.pull_requests
    where pr_repository_name is not null
)
select
    count(*) as prs,
    count(distinct pr_repository_name) as repos,
    count(distinct split_part(pr_repository_name, '-', 1)) as repo_groups,
    count(distinct pr_author_github_username) as authors
from base
