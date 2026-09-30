# NYC Taxi Analytics (dbt + DuckDB)

An analytics engineering project built on NYC TLC yellow taxi data. Raw Parquet files (Hive-partitioned by year/month) are read in place by DuckDB and transformed with dbt into tested, documented marts.

![CI](https://github.com/<your-username>/nyc-taxi-dbt/actions/workflows/ci.yml/badge.svg)

## Architecture

```
TLC Parquet (year=/month= partitions)  -->  source  -->  staging (views)  -->  marts (tables / incremental)
         local disk now, S3 later              |              |                        |
                                          freshness      rename/cast/clean      fct_trips, dim_zones,
                                                                                mart_daily_revenue_by_borough
```

| Layer | Models | Materialization | Purpose |
|---|---|---|---|
| Source | `taxi_raw.yellow_trips` | external Parquet | Raw files, untouched |
| Staging | `stg_taxi__trips`, `stg_taxi__zones` | view | Rename, cast, drop bad timestamps |
| Marts | `fct_trips` | incremental (`delete+insert`) | Trip-level fact |
| Marts | `dim_zones` | table | Zone/borough dimension |
| Marts | `mart_daily_revenue_by_borough` | table | Business-facing aggregate |

## Quickstart

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

python scripts/download_data.py --year 2024 --months 1 2 3
dbt deps --profiles-dir .
dbt build --profiles-dir .
dbt docs generate --profiles-dir . && dbt docs serve --profiles-dir .
```

## Design decisions

- **Parquet, Hive-partitioned**: columnar + compressed, and partition columns let the engine skip files. *(Add your own measurements here: filtered vs unfiltered scan time.)*
- **DuckDB**: zero-cost local warehouse that reads Parquet directly. The dbt code is portable; swapping adapters mainly touches `profiles.yml` and a few functions (`date_diff`, `interval`).
- **Incremental `fct_trips`**: only new trips are processed each run; `unique_key=trip_id` with `delete+insert` makes reruns idempotent.
- **Staging is dumb on purpose**: no joins or business logic until marts.
- **Bad data is filtered explicitly** via `min_pickup_date` / `max_pickup_date` vars rather than silently.

## Data quality

See `LEARNING.md` for findings. *(Replace with a real issue your tests caught in the taxi data.)*

## What I'd do next

- Move raw files to S3 and read them via `httpfs`
- Add source freshness and a `state:modified+` slim CI job
- Publish docs to GitHub Pages
- Add a snapshot for zone changes
