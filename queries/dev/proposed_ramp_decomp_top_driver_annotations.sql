with ranked as (
    select
        row_number() over (
            order by combined_driver_rank, benchmark_by_day_90, median_prs_60_89, median_prs_30_59, factor_label
        ) as driver_rank,
        *
    from ${proposed_ramp_decomp_top_driver_candidates}
)
select
    max(case when driver_rank = 1 then factor_label end) as top_1_factor,
    max(case when driver_rank = 1 then driver_signal end) as top_1_signal,
    max(case when driver_rank = 1 then median_prs_30_59 end) as top_1_prs_30_59,
    max(case when driver_rank = 1 then median_prs_60_89 end) as top_1_prs_60_89,
    max(case when driver_rank = 1 then benchmark_by_day_90 end) as top_1_benchmark_90,
    max(case when driver_rank = 2 then factor_label end) as top_2_factor,
    max(case when driver_rank = 2 then driver_signal end) as top_2_signal,
    max(case when driver_rank = 2 then median_prs_30_59 end) as top_2_prs_30_59,
    max(case when driver_rank = 2 then median_prs_60_89 end) as top_2_prs_60_89,
    max(case when driver_rank = 2 then benchmark_by_day_90 end) as top_2_benchmark_90,
    max(case when driver_rank = 3 then factor_label end) as top_3_factor,
    max(case when driver_rank = 3 then driver_signal end) as top_3_signal,
    max(case when driver_rank = 3 then median_prs_30_59 end) as top_3_prs_30_59,
    max(case when driver_rank = 3 then median_prs_60_89 end) as top_3_prs_60_89,
    max(case when driver_rank = 3 then benchmark_by_day_90 end) as top_3_benchmark_90
from ranked
