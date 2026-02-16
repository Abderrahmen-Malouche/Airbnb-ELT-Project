{{ config(materialized="incremental",unique_key="listing_id")}}

select 
    listing_id,
    host_id,
    property_type,
    room_type,
    country,
    accommodates,
    bedrooms,
    bathrooms,
    nightly_price,
    created_at
FROM {{ref('bronze_listings')}}