-- Staging rule: rename, cast, light cleaning. No joins, no business logic.
with source as (

    select * from {{ source('taxi_raw', 'yellow_trips') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key([
            'VendorID', 'tpep_pickup_datetime', 'tpep_dropoff_datetime',
            'PULocationID', 'DOLocationID', 'total_amount'
        ]) }}                                        as trip_id,
        cast(VendorID as integer)                    as vendor_id,
        cast(tpep_pickup_datetime as timestamp)      as pickup_at,
        cast(tpep_dropoff_datetime as timestamp)     as dropoff_at,
        cast(passenger_count as integer)             as passenger_count,
        cast(trip_distance as double)                as trip_distance_miles,
        cast(PULocationID as integer)                as pickup_location_id,
        cast(DOLocationID as integer)                as dropoff_location_id,
        cast(payment_type as integer)                as payment_type_id,
        cast(fare_amount as double)                  as fare_amount,
        cast(tip_amount as double)                   as tip_amount,
        cast(total_amount as double)                 as total_amount
    from source

)

select *
from renamed
where pickup_at >= cast('{{ var("min_pickup_date") }}' as timestamp)
  and pickup_at <  cast('{{ var("max_pickup_date") }}' as timestamp) + interval 1 day
