select
    row_number() over (
        order by combined_driver_rank, benchmark_by_day_90, median_prs_60_89, median_prs_30_59, factor_label
    ) as driver_rank,
    dimension,
    dimension_label,
    group_label,
    factor_label,
    hires,
    median_prs_30_59,
    median_prs_60_89,
    benchmark_by_day_90,
    driver_signal,
    combined_driver_rank
from ${proposed_ramp_decomp_top_driver_candidates}
qualify driver_rank <= 8
order by driver_rank
