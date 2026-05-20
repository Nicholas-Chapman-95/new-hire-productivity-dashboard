with ranked as (
    select
        *,
        row_number() over (order by abs(total_contribution) desc, dimension, factor_label) as contribution_rank
    from ${proposed_setup_decomp_top_driver_candidates_pct30}
)
select
    contribution_rank,
    dimension,
    dimension_label,
    group_label,
    factor_label,
    reference_hires,
    selected_hires,
    reference_metric_value,
    selected_metric_value,
    mix_component,
    rate_component,
    total_contribution
from ranked
where contribution_rank <= 8
order by contribution_rank

