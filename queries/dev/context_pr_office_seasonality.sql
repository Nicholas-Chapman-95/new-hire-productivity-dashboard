with office_monthly as (
    select
        strftime(pr_merged_month, '%Y-%m') as month,
        attributed_employee_office as office,
        count(*) as prs
    from productivity.pull_requests
    where pr_merged_month >= date '2025-03-01'
      and pr_merged_month < date '2026-03-01'
      and attributed_employee_office in ('London', 'Tallinn')
    group by 1, 2
)
select
    cast(month || '-01' as date) as month_date,
    month,
    office,
    prs
from office_monthly
order by month_date, office
