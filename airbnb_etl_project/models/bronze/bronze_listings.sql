select 
    listing_id::int                     AS listing_id,
    host_id::int                        AS host_id,
    lower(trim(property_type))          AS property_type,
    lower(trim(room_type))              AS room_type,
    trim(city)                          AS city,
    trim(country)                       AS country,
    accommodates::int                   AS accommodates,
    bedrooms::int                       AS bedrooms,
    bathrooms::int                      AS bathrooms,
    price_per_night::numeric            AS nightly_price,
    created_at::timestamp               AS created_at
FROM {{ source("staging", "listings") }}