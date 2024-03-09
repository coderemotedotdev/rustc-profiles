# Rustc Profiles
I have optimized `rustc`, the Rust compiler. My mod greatly *shortens your edit-compile-run cycle*. That means
1. Faster incremental builds
2. Less lag in your IDE's IntelliSense

## Why? I'm improving dev productivity at [coderemote.dev](https://coderemote.dev)
I like writing in Rust, but Rust is rightly notorious for its slow compile times. I am building better developer productivity tooling for Rust. Do you want
1. this optimized compiler on a heavy-duty managed remote build server? Or
2. to try out the compiler on your own hardware? Or
3. to shoot the breeze?

[Reach out!](#contact-me)

## Summary of incremental build speed-ups
| Project      | % speed-up | Default compiler's build time | Our compiler's build time | Detailed analysis?
| ------------- | ------------- | ------------- | ------------- | ------------- |
| [hedgehog](https://hedgehog.app/) | 40% | 19.3 s | 11.7 s | [Here, in this repo](hedgehog)
| [polkadot-sdk](https://github.com/paritytech/polkadot-sdk) | 35% | 30 s | 19 s | [Here, in this repo](polkadot-sdk)
| [brontes](https://github.com/SorellaLabs/brontes) | 25% | 10.7 s | 8.0 s | [Here, in this repo](brontes)
| [graph-node](https://github.com/graphprotocol/graph-node) | 21% | 6.3 s | 5.0 s | [Here, in this repo](graph-node)
| [vector](https://github.com/vectordotdev/vector) | 11% | 18.4 s | 16.4 s | [In vector's GitHub discussion](https://github.com/vectordotdev/vector/discussions/19930)

## Contact me
Please feel free to open a GitHub issue, or email me at <kapil@coderemote.dev>

