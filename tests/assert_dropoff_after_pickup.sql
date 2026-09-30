-- Singular test: returns rows that violate the rule. Test passes when zero rows come back.
select trip_id, pickup_at, dropoff_at
from {{ ref('fct_trips') }}
where dropoff_at < pickup_at
