
select 
    host_id::int             AS host_id,
    trim(host_name)          AS host_name,
    host_since::date         AS host_since,
    is_superhost::boolean    AS is_superhost,
    CASE 
        WHEN response_rate between 0 AND 100 THEN response_rate
        ELSE NULL
    END AS response_rate,
    created_at::timestamp    AS created_at
FROM {{source("staging","hosts")}}

