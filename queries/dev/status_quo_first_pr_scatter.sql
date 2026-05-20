select
    cast(hire_date as date) as hire_date_axis,
    days_to_first_pr,
    office,
    team,
    sub_team,
    squad,
    job_family_group,
    job_family,
    employee_type,
    management_level,
    'L' || cast(cast(management_level as integer) as varchar) as level_label,
    case
        when '${inputs.color_by.value}' = 'office' then office
        when '${inputs.color_by.value}' = 'level' then 'L' || cast(cast(management_level as integer) as varchar)
        when '${inputs.color_by.value}' = 'squad' then squad
        when '${inputs.color_by.value}' = 'team' then team
        when '${inputs.color_by.value}' = 'sub_team' then sub_team
        when '${inputs.color_by.value}' = 'job_family_group' then job_family_group
        when '${inputs.color_by.value}' = 'job_family' then job_family
        else 'L' || cast(cast(management_level as integer) as varchar)
    end as series_label,
    cohort_month
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
  and (
      case
          when '${inputs.color_by.value}' = 'office' then office
          when '${inputs.color_by.value}' = 'level' then 'L' || cast(cast(management_level as integer) as varchar)
          when '${inputs.color_by.value}' = 'squad' then squad
          when '${inputs.color_by.value}' = 'team' then team
          when '${inputs.color_by.value}' = 'sub_team' then sub_team
          when '${inputs.color_by.value}' = 'job_family_group' then job_family_group
          when '${inputs.color_by.value}' = 'job_family' then job_family
          else 'L' || cast(cast(management_level as integer) as varchar)
      end
  ) is not null
order by 1, 2
