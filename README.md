# essential-tuple-lake

The **feature store** for [weftspun](https://github.com/weftspun) — one relation per parquet file,
content-addressable UUIDv5 identity, and PK-unique / FK-resolves integrity.

Hexagonal:
- `core/` — identity (stable UUIDv5 keys) + integrity (PK/FK checks), zero deps
- `ports/` — `RelationSource` (read) / `RelationSink` (write)
- `adapters/` — Explorer/Polars parquet

Elixir, shipped as a self-contained binary via Burrito.

```sh
mix deps.get && mix test
```

## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE))
- MIT license ([LICENSE-MIT](LICENSE-MIT))

at your option. Each source file carries an `SPDX-License-Identifier: MIT OR Apache-2.0` tag.

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in
this work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without any
additional terms or conditions.
