select
    t.pickup_date,
    z.borough                as pickup_borough,
    count(*)                 as trip_count,
    sum(t.total_amount)      as total_revenue,
    avg(t.trip_distance_miles) as avg_trip_distance_miles,
    sum(t.tip_amount) / nullif(sum(t.fare_amount), 0) as tip_rate
from {{ ref('fct_trips') }} t
left join {{ ref('dim_zones') }} z
    on t.pickup_zone_id = z.zone_id
group by 1, 2
