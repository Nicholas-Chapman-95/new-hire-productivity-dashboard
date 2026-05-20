with base as (
    select
        hire_date,
        office,
        squad,
        sub_team,
        management_level,
        days_to_first_pr,
        first_pr_repository_name,
        case
            when '${inputs.cadence_context.value}' = 'office' then coalesce(office_nearest_hire_gap_days, 9999)
            else coalesce(squad_nearest_hire_gap_days, 9999)
        end as nearest_hire_gap_days,
        case
            when '${inputs.cadence_context.value}' = 'office' then coalesce(office_other_hires_within_30_days, 0)
            else coalesce(squad_other_hires_within_30_days, 0)
        end as other_hires_within_30_days
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category like '${inputs.role_productivity_category.value}'
      and employee_type like '${inputs.employee_type.value}'
      and squad like '${inputs.squad.value}'
      and sub_team like '${inputs.sub_team.value}'
      and cast(management_level as varchar) like '${inputs.management_level.value}'
      and days_to_first_pr is not null
      and office = case
          when '${inputs.office.value}' = '%' then 'London'
          else '${inputs.office.value}'
      end
),
flagged as (
    select
        hire_date,
        office,
        squad,
        sub_team,
        management_level,
        nearest_hire_gap_days,
        other_hires_within_30_days,
        days_to_first_pr,
        first_pr_repository_name,
        case
            when other_hires_within_30_days = 0 and nearest_hire_gap_days >= 90 then 'Very low cadence'
            when other_hires_within_30_days = 0 and nearest_hire_gap_days >= 60 then 'Low cadence'
            when other_hires_within_30_days = 0 then 'No nearby hire within 30 days'
            else 'Nearby hire exists'
        end as cadence_case
    from base
)
select
    cast(hire_date as date) as hire_date,
    office,
    squad,
    sub_team,
    management_level,
    cadence_case,
    nearest_hire_gap_days,
    other_hires_within_30_days,
    days_to_first_pr,
    first_pr_repository_name
from flagged
order by nearest_hire_gap_days desc, days_to_first_pr desc, hire_date desc
limit 12
