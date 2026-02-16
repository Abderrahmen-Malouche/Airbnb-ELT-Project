{{ config(
    materialized='incremental',
    unique_key='booking_id'
) }}

SELECT 
        -- Primary / degenerate key
        booking_id,

    -- Foreign keys
        listing_id,
        host_id,

    -- Dates
        booking_date,
        created_at,

    -- Measures
        nights_booked,
        booking_amount,
        cleaning_fee,
        service_fee,
        total_amount,

    -- Flags & status
        is_long_stay,
        booking_status
    FROM {{ref('obt')}}