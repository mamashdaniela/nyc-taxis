# Learning checklist (dbt fundamentals)

Work through these in order. Each maps to a certification topic. Delete the TODO markers as you go and note findings at the bottom; this file becomes your "data quality story".

## Already scaffolded (read and understand it, then modify it)
- [ ] `sources.yml` and `source()` — `models/staging/taxi/_taxi__sources.yml`
- [ ] `ref()` and the DAG — run `dbt docs serve` and open the lineage graph
- [ ] Seeds — `seeds/taxi_zone_lookup.csv`
- [ ] Materializations: view (staging), table (marts), incremental (`fct_trips`)
- [ ] Generic tests: `unique`, `not_null`, `relationships`, `accepted_values`
- [ ] Singular test — `tests/assert_dropoff_after_pickup.sql`
- [ ] Macro + Jinja — `macros/payment_type_description.sql`
- [ ] Package — `dbt_utils` (surrogate key, unique combination)
- [ ] Vars — `dbt_project.yml`
- [ ] CI — `.github/workflows/ci.yml`

## Exercises
1. Download the full zones CSV (`--zones`), rename columns to match the seed header, and replace the sample seed. Does the `relationships` warning go away?
2. Run `dbt build`, then `dbt build -s fct_trips` again. Explain what the incremental run did. Then run `dbt build --full-refresh`.
3. Download several months. Does `unique_stg_taxi__trips_trip_id` pass? Investigate any failures.
4. Add `dbt_utils.accepted_range` tests for `trip_distance_miles` and `total_amount`. Which bounds are realistic?
5. Write a second macro (e.g. `cents_to_dollars` or a `trip_distance_bucket`) and use it in a mart.
6. Add a `freshness` block to the source (needs `loaded_at_field`) and run `dbt source freshness`.
7. Add `description:` to every column and check the docs site.
8. Try selectors: `dbt build -s +mart_daily_revenue_by_borough`, `-s staging`, `--exclude fct_trips`.
9. Add `dbt_project_evaluator` or a `dbt build --select state:modified+` slim CI job.
10. Put the Parquet files in S3 and change the source `external_location`.

## Findings
- (write here)
