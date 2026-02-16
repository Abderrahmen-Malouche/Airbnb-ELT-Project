{{ config(materialized="incremental",unique_key="host_id")}}

select 
    host_id,
    host_name,
    host_since,
    is_superhost,
    response_rate,
    {{response_consistency('response_rate')}}   AS response_consistency,
    created_at
FROM {{ref("bronze_hosts")}}

