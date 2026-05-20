with base as (
    select
        count(*) as total_prs,
        sum(case when pr_created_at > pr_merged_at and pr_merged_at is not null then 1 else 0 end) as created_after_merged,
        sum(case when pr_created_at > pr_closed_at and pr_closed_at is not null then 1 else 0 end) as created_after_closed,
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
    issue_label,
    prs,
    round(prs * 100.0 / nullif(total_prs, 0), 1) as pct_total,
    sort_order
from base,
(
    select 'Created after merged_at' as issue_label, created_after_merged as prs, 1 as sort_order from base
    union all
    select 'Created after closed_at' as issue_label, created_after_closed as prs, 2 as sort_order from base
    union all
    select 'Created after both timestamps' as issue_label, both_bad as prs, 3 as sort_order from base
)
order by sort_order
