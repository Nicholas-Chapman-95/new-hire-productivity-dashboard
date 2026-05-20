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
        *,
        case
            when '${inputs.comparison_dimension.value}' = 'job_family_group' then job_family_group
            when '${inputs.comparison_dimension.value}' = 'job_family' then job_family
            when '${inputs.comparison_dimension.value}' = 'team' then team
            when '${inputs.comparison_dimension.value}' = 'sub_team' then sub_team
            when '${inputs.comparison_dimension.value}' = 'squad' then squad
            else squad
        end as comparison_key
    from base
),
slice as (
    select *
    from shaped
    where comparison_key like '${inputs.comparison_value.value}'
),
benchmark as (
    select *
    from shaped
    where case
        when '${inputs.benchmark_mode.value}' = 'overall' then true
        when '${inputs.benchmark_mode.value}' = 'all_other_values'
            then '${inputs.comparison_value.value}' <> '%'
             and comparison_key <> '${inputs.comparison_value.value}'
        when '${inputs.benchmark_mode.value}' = 'selected_value'
            then comparison_key like '${inputs.benchmark_value.value}'
        else true
    end
),
slice_cohorts as (
    select
        strptime(cohort_month || '-01', '%Y-%m-%d') as cohort_date,
        median(days_to_first_pr) as median_days_to_first_pr
    from slice
    group by 1
),
benchmark_cohorts as (
    select
        strptime(cohort_month || '-01', '%Y-%m-%d') as cohort_date,
        median(days_to_first_pr) as median_days_to_first_pr
    from benchmark
    group by 1
)
select
    cohort_date,
    'Selected Slice' as series,
    median_days_to_first_pr as days_to_first_pr
from slice_cohorts
union all
select
    cohort_date,
    'Benchmark' as series,
    median_days_to_first_pr as days_to_first_pr
from benchmark_cohorts
order by 1, 2
