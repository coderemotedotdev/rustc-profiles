# Profiling polkadot-sdk incremental builds
We profile https://github.com/paritytech/polkadot-sdk, the code behind the Polkadot blockchain and core of all Substrate-based chains.w

## Results
Our modded compiler is **35% faster than the default compiler**. We shrank **incremental build time from 30 seconds to 19 seconds**. Full timings reports, and an analysis/report are attached.
- [Analysis](polkadot_sdk_compiler_comparison_report.pdf)
- [Full timings report for default compiler](https://htmlpreview.github.io/?https://github.com/kapilsinha/rustc-profiles/blob/main/polkadot-sdk/cargo-timing-default-compiler.html)
- [Full timings report for modded compiler](https://htmlpreview.github.io/?https://github.com/kapilsinha/rustc-profiles/blob/main/polkadot-sdk/cargo-timing-modded-compiler.html)

## Procedure

### 'Default' (nightly Feb 29) compiler
```bash
# Full cargo check
polkadot-sdk/polkadot$ SKIP_WASM_BUILD=1 RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo check --target-dir target-nightly --timings
# Simulate a code change
polkadot-sdk/polkadot$ touch ../substrate/primitives/weights/src/lib.rs
# Incremental cargo check
polkadot-sdk/polkadot$ SKIP_WASM_BUILD=1 RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo check --target-dir target-nightly --timings
```

### 'Modded' custom compiler
```bash
# Full cargo check
polkadot-sdk/polkadot$ SKIP_WASM_BUILD=1 RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +kaprust check --target-dir target-kap --timings
# Simulate a code change
polkadot-sdk/polkadot$ touch ../substrate/primitives/weights/src/lib.rs
# Incremental cargo check
polkadot-sdk/polkadot$ SKIP_WASM_BUILD=1 RUSTFLAGS="-C linker=/usr/bin/clang -Zself-profile -Zself-profile-events=default,args -Zthreads=8 --cfg tokio_unstable" cargo +kaprust check --target-dir target-kap --timings
```

