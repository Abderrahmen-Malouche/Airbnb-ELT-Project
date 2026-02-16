{{ config(materialized='ephemeral') }}
WITH hosts AS (
    SELECT 
        LISTING_ID,
        LISTING_CREATION,
        BATHROOMS,
        BEDROOMS,
        COUNTRY,
        NIGHTLY_PRICE,
    FROM {{ ref('obt') }}
)
SELECT * FROM hosts
