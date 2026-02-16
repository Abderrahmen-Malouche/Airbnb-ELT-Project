{{ config(materialized="incremental",unique_key="booking_id")}}
select 
    booking_id,
    listing_id,
    booking_date,
    nights_booked,
    {{ is_long_stay('nights_booked')}}              AS is_long_stay,
    booking_amount,
    cleaning_fee,
    service_fee,
    booking_amount + cleaning_fee + service_fee    AS total_amount,
    booking_status,
    created_at
FROM 
    {{ref("bronze_bookings")}}