with base as (
    select
        count(*) as total_prs,
        sum(case when pr_created_at > pr_merged_at and pr_merged_at is not null then 1 else 0 end) as created_after_merged,
        sum(case when pr_created_at > pr_closed_at and pr_closed_at is not null then 1 else 0 end) as created_after_closed,
        sum(
            case
                when (pr_created_at > pr_merged_at and pr_merged_at is not null)
                  or (pr_created_at > pr_closed_at and pr_closed_at is not null)
                then 1
                else 0
            end
        ) as any_timestamp_issue,
        sum(
            case
                when pr_created_at > pr_merged_at and pr_merged_at is not null
                 and pr_created_at > pr_closed_at and pr_closed_at is not null
                then 1
                else 0
            end
        ) as both_bad
    from productivity.pull_requests
)
select
    total_prs,
    created_after_merged,
    created_after_closed,
    any_timestamp_issue,
    both_bad,
    any_timestamp_issue * 1.0 / nullif(total_prs, 0) as pct_with_any_timestamp_issue
from base
