select
    pr_id,
    pr_author_github_username,
    pr_repository,
    pr_state,
    pr_created_at,
    pr_merged_at,
    pr_closed_at,
    round(date_diff('minute', pr_merged_at, pr_created_at) / 60.0, 2) as created_minus_merged_hours,
    round(date_diff('minute', pr_closed_at, pr_created_at) / 60.0, 2) as created_minus_closed_hours
from productivity.pull_requests
where (pr_created_at > pr_merged_at and pr_merged_at is not null)
   or (pr_created_at > pr_closed_at and pr_closed_at is not null)
order by pr_created_at desc
limit 20
