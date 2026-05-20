with valid_new_hires as (
    select
        squad,
        first_pr_repository_name
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and first_pr_repository_name is not null
),
repo_counts as (
    select
        squad,
        first_pr_repository_name,
        count(*) as hires,
        row_number() over (
            partition by squad
            order by count(*) desc, first_pr_repository_name
        ) as repo_rank
    from valid_new_hires
    group by 1, 2
)
select
    squad,
    sum(hires) as hires,
    count(*) as distinct_first_pr_repos,
    max(case when repo_rank = 1 then first_pr_repository_name end) as top_first_pr_repo,
    max(case when repo_rank = 1 then hires end) as top_first_pr_repo_hires,
    round(max(case when repo_rank = 1 then hires end) * 100.0 / sum(hires), 1) as top_first_pr_repo_share_pct,
    round(sum(case when repo_rank <= 3 then hires else 0 end) * 100.0 / sum(hires), 1) as top3_first_pr_repo_share_pct
from repo_counts
group by 1
order by hires desc, squad
