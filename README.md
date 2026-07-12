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
