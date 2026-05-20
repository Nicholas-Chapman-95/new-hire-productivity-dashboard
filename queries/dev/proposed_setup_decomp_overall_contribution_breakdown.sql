with filtered as (
    select
        case
            when '${inputs.overall_contribution_dimension.value}' = 'office' then office
            when '${inputs.overall_contribution_dimension.value}' = 'level' then 'L' || cast(cast(management_level as integer) as varchar)
            when '${inputs.overall_contribution_dimension.value}' = 'cross_office_squad_status' then cross_office_squad_status
            when '${inputs.overall_contribution_dimension.value}' = 'sub_team' then sub_team
            else squad
        end as group_label,
        case
            when '${inputs.overall_contribution_dimension.value}' = 'level' then cast(management_level as integer)
            else null
        end as sort_key,
        case
            when '${inputs.day_basis.value}' = 'business' then business_days_to_first_pr
            else days_to_first_pr
        end as selected_days_to_first_pr
    from productivity.onboarding_summary
    where is_true_onboarding_metric = true
      and role_productivity_category = 'Software Engineering'
      and employee_type = 'Permanent'
      and cohort_month between '2025-03' and '2026-02'
),
overall as (
    select
        count(*) as total_hires,
        avg(selected_days_to_first_pr) as overall_mean_days
    from filtered
    where selected_days_to_first_pr is not null
),
grouped as (
    select
        group_label,
        min(sort_key) as sort_key,
        count(*) as hires,
        avg(selected_days_to_first_pr) as mean_days_to_first_pr,
        median(selected_days_to_first_pr) as median_days_to_first_pr
    from filtered
    where group_label is not null
      and selected_days_to_first_pr is not null
    group by 1
)
select
    group_label,
    sort_key,
    hires,
    round(hires * 100.0 / o.total_hires, 1) as hire_share_pct,
    round(mean_days_to_first_pr, 1) as mean_days_to_first_pr,
    round(median_days_to_first_pr, 1) as median_days_to_first_pr,
    round((hires * 1.0 / o.total_hires) * mean_days_to_first_pr, 2) as contribution_to_overall_mean,
    round(((hires * 1.0 / o.total_hires) * mean_days_to_first_pr) * 100.0 / o.overall_mean_days, 1) as contribution_share_of_overall_mean_pct,
    round(mean_days_to_first_pr - o.overall_mean_days, 2) as mean_gap_vs_overall,
    round((hires * 1.0 / o.total_hires) * (mean_days_to_first_pr - o.overall_mean_days), 2) as net_pull_vs_overall_mean,
    round(o.overall_mean_days, 1) as overall_mean_days
from grouped
cross join overall o
where hires >= case
    when '${inputs.overall_contribution_dimension.value}' = 'cross_office_squad_status' then 1
    when '${inputs.overall_contribution_dimension.value}' = 'squad' then 2
    else 3
end
order by
    case when '${inputs.overall_contribution_dimension.value}' = 'level' then sort_key end,
    case when '${inputs.overall_contribution_dimension.value}' != 'level' then net_pull_vs_overall_mean end desc,
    group_label
