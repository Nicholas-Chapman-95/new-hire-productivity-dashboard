select
    pr_merged_month as month,
    count(*) as prs
from productivity.pull_requests
where pr_merged_month is not null
group by 1
order by 1
