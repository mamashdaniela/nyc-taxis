{{
    config(
        materialized='incremental',
        unique_key='trip_id',
        incremental_strategy='delete+insert'
    )
}}

with trips as (

    select * from {{ ref('stg_taxi__trips') }}

    {% if is_incremental() %}
    -- only process trips newer than what's already in this table
    where pickup_at > (select max(pickup_at) from {{ this }})
    {% endif %}

)

select
    trip_id,
    vendor_id,
    pickup_at,
    cast(pickup_at as date)                          as pickup_date,
    dropoff_at,
    date_diff('minute', pickup_at, dropoff_at)       as trip_duration_minutes,
    passenger_count,
    trip_distance_miles,
    pickup_location_id                               as pickup_zone_id,
    dropoff_location_id                              as dropoff_zone_id,
    {{ payment_type_description('payment_type_id') }} as payment_type,
    fare_amount,
    tip_amount,
    total_amount
from trips
