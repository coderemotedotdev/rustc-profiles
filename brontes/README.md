# Profiling brontes incremental builds
We profile https://github.com/SorellaLabs/brontes, an MEV tracing system.

## Results
Our modded compiler is **25% faster than the default compiler**. We shrank **incremental build time from 10.74 to 8.02 seconds**. Full timings reports, and an analysis/report are attached.
- [Analysis](brontes_compiler_comparison_report.pdf)
- [Full timings report for default compiler](https://htmlpreview.github.io/?https://github.com/kapilsinha/rustc-profiles/blob/main/brontes/cargo-timing-default-compiler.html)
- [Full timings report for modded compiler](https://htmlpreview.github.io/?https://github.com/kapilsinha/rustc-profiles/blob/main/brontes/cargo-timing-modded-compiler.html)

## Procedure

### 'Default' (nightly Feb 14) compiler
```bash
# Full cargo check
brontes$ RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +nightly check --target-dir target-nightly --timings
# Simulate a code change
brontes$ touch crates/brontes-types/src/lib.rs
# Incremental cargo check
brontes$ RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +nightly check --target-dir target-nightly --timings
```

### 'Modded' custom compiler
```bash
# Full cargo check
brontes$ RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +kap check --target-dir target-kap --timings
# Simulate a code change
brontes$ touch crates/brontes-types/src/lib.rs
# Incremental cargo check
brontes$ RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +kap check --target-dir target-kap --timings
```

## Appendix
### Note with respect to benchmarking
Now that we have implemented a benchmarking script at `../scripts/benchmark_incremental_builds_brontes.sh`, we trust these results more (as it averages across 10 runs) and use those timing figures above. This is why you will see a discrepancy between the times reported above and the ones in the reports. For full transparency, below is the output of that script:
<details>
<summary>Benchmark script output</summary>

```bash
Performing full build of nightly-2024-02-14...
Performing full build of kapnightly-2024-02-23...
Iteration 1 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 11.06 s
  Most recent: 11.06 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.20 s
  Most recent: 8.20 s

Iteration 2 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 10.97 s
  Most recent: 10.88 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.30 s
  Most recent: 8.41 s

Iteration 3 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 10.97 s
  Most recent: 10.97 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.26 s
  Most recent: 8.18 s

Iteration 4 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 10.89 s
  Most recent: 10.67 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.14 s
  Most recent: 7.80 s

Iteration 5 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 10.81 s
  Most recent: 10.47 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.09 s
  Most recent: 7.86 s

Iteration 6 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 10.76 s
  Most recent: 10.51 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.04 s
  Most recent: 7.80 s

Iteration 7 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 10.72 s
  Most recent: 10.49 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.01 s
  Most recent: 7.87 s

Iteration 8 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 10.72 s
  Most recent: 10.76 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.03 s
  Most recent: 8.16 s

Iteration 9 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 10.73 s
  Most recent: 10.79 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.02 s
  Most recent: 7.97 s

Iteration 10 of 10:
nightly-2024-02-14 incremental runtime:
  Running average: 10.74 s
  Most recent: 10.89 s
kapnightly-2024-02-23 incremental runtime:
  Running average: 8.02 s
  Most recent: 8.03 s

nightly-2024-02-14 avg incremental runtime: 10.74 s
kapnightly-2024-02-23 avg incremental runtime: 8.02 s
```
</details>

