# Profiling hedgehog-rust-server incremental builds
We profile the Rust server repository for https://hedgehog.app/, a robo-adviser app. The Hedegehog team has graciously shared their repo with me to profile. Because it is closed source, we do not provide as much granular information as for the other projects profiled in this repo.

## Results
Our modded compiler is **40% faster than the default compiler**. We shrank **incremental build time from 19.27 to 11.66 seconds**. Attached below is the analysis/report.
- [Analysis](hedgehog_compiler_comparison_report.pdf)

## Appendix
### Note with respect to benchmarking
Now that we have implemented a benchmarking script at `../scripts/benchmark_incremental_builds_hedgehog.sh`, we trust these results more (as it averages across 5 runs) and use those timing figures above. Below is the output of that script:
<details>
<summary>Benchmark script output</summary>

```bash
Performing full build of nightly-2024-01-25...
Performing full build of kapnightly-2024-02-14...
Iteration 1 of 5:
nightly-2024-01-25 incremental runtime:
  Running average: 19.56 s
  Most recent: 19.56 s
kapnightly-2024-02-14 incremental runtime:
  Running average: 12.68 s
  Most recent: 12.68 s

Iteration 2 of 5:
nightly-2024-01-25 incremental runtime:
  Running average: 19.34 s
  Most recent: 19.12 s
kapnightly-2024-02-14 incremental runtime:
  Running average: 12.04 s
  Most recent: 11.41 s

Iteration 3 of 5:
nightly-2024-01-25 incremental runtime:
  Running average: 19.31 s
  Most recent: 19.25 s
kapnightly-2024-02-14 incremental runtime:
  Running average: 11.85 s
  Most recent: 11.46 s

Iteration 4 of 5:
nightly-2024-01-25 incremental runtime:
  Running average: 19.29 s
  Most recent: 19.23 s
kapnightly-2024-02-14 incremental runtime:
  Running average: 11.73 s
  Most recent: 11.39 s

Iteration 5 of 5:
nightly-2024-01-25 incremental runtime:
  Running average: 19.27 s
  Most recent: 19.21 s
kapnightly-2024-02-14 incremental runtime:
  Running average: 11.66 s
  Most recent: 11.40 s

nightly-2024-01-25 avg incremental runtime: 19.27 s
kapnightly-2024-02-14 avg incremental runtime: 11.66 s
```
</details>

