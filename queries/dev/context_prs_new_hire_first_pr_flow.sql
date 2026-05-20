with base as (
    select
        squad,
        split_part(first_pr_repository_name, '-', 1) as repo_group,
        count(*) as hires
    from productivity.onboarding_summary
    where first_pr_repository_name is not null
      and employee_type = 'Permanent'
      and role_productivity_category = 'Software Engineering'
      and is_true_onboarding_metric = true
    group by 1, 2
),
top_repo_groups as (
    select repo_group
    from (
        select repo_group, sum(hires) as total_hires
        from base
        group by 1
        order by total_hires desc, repo_group
        limit 8
    )
)
select
    squad as source,
    repo_group as target,
    hires as value
from base
where repo_group in (select repo_group from top_repo_groups)
order by value desc, source, target
