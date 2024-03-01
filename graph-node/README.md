# Profiling graph-node incremental builds
We profile https://github.com/graphprotocol/graph-node, an indexer implementation for The Graph protocol.

## Results
Our modded compiler is **21% faster than the default compiler**. We shrank **incremental build time from 6.3 seconds to 5.0 seconds**. Full timings reports, and an analysis/report are attached.
- [Analysis](graph_node_compiler_comparison_report.pdf)
- [Full timings report for default compiler](https://htmlpreview.github.io/?https://github.com/kapilsinha/rustc-profiles/blob/main/graph-node/cargo-timing-default-compiler.html)
- [Full timings report for modded compiler](https://htmlpreview.github.io/?https://github.com/kapilsinha/rustc-profiles/blob/main/graph-node/cargo-timing-modded-compiler.html)

## Procedure

### 'Default' (nightly Feb 29) compiler
```bash
# Full cargo check
graph-node$ RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +nightly check --target-dir target-nightly --timings
# Simulate a code change
graph-node$ touch graph/src/schema/api.rs
# Incremental cargo check
graph-node$ RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +nightly check --target-dir target-nightly --timings
```

### 'Modded' custom compiler
```bash
# Full cargo check
graph-node$ RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +kap check --target-dir target-nightly --timings
# Simulate a code change
graph-node$ touch graph/src/schema/api.rs
# Incremental cargo check
graph-node$ RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +kap check --target-dir target-nightly --timings
```

