select 
    trim(booking_id)                    AS booking_id,
    listing_id::int                     AS listing_id,
    booking_date::date                  AS booking_date,
    nights_booked::int                  AS nights_booked,
    booking_amount::numeric             AS booking_amount,
    cleaning_fee::numeric               AS cleaning_fee,
    service_fee::numeric                AS service_fee,
    CASE 
        WHEN lower(trim(booking_status)) IN ('confirmed', 'cancelled') THEN lower(trim(booking_status))
        ELSE NULL
    END                                 AS booking_status,
    created_at::timestamp               AS created_at
FROM 
    {{source("staging","bookings")}}