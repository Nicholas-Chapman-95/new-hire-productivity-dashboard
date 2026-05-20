with base as (
    select *
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and in_reliability_window = 1
      and role_productivity_category like '${inputs.role_productivity_category.value}'
      and employee_type like '${inputs.employee_type.value}'
      and office like '${inputs.office.value}'
      and squad like '${inputs.squad.value}'
      and team like '${inputs.team.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
      and days_to_first_pr is not null
),
shaped as (
    select
        case
            when '${inputs.comparison_dimension.value}' = 'job_family_group' then job_family_group
            when '${inputs.comparison_dimension.value}' = 'job_family' then job_family
            when '${inputs.comparison_dimension.value}' = 'team' then team
            when '${inputs.comparison_dimension.value}' = 'sub_team' then sub_team
            when '${inputs.comparison_dimension.value}' = 'squad' then squad
            else squad
        end as comparison_key
    from base
)
select
    comparison_key as value,
    comparison_key || ' (' || cast(count(*) as varchar) || ')' as label,
    count(*) as hires
from shaped
where comparison_key is not null
group by 1
order by hires desc, value
