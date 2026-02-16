{{ config(materialized='ephemeral') }}
WITH hosts AS (
    SELECT 
        host_id,
        host_name,
        host_creation,
        is_superhost,
        response_rate,
        response_consistency
    FROM {{ ref('obt') }}
)
SELECT * FROM hosts
