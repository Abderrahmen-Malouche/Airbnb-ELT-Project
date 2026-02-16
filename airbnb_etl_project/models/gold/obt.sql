{% set configs = [
    {
        "model": "silver_bookings",
        "alias": "sb",
        "columns": "sb.*"
    },
    {
        "model": "silver_listings",
        "alias": "sl",
        "columns": "sl.host_id,sl.property_type,sl.room_type,sl.country,sl.accommodates,sl.bedrooms,sl.bathrooms,sl.nightly_price,sl.created_at as listing_creation",
        "join_condition": "sb.listing_id = sl.listing_id"
    },
    {
        "model": "silver_hosts",
        "alias": "sh",
        "columns": "sh.host_name,sh.host_since,sh.is_superhost,sh.response_rate,sh.response_consistency,sh.created_at as host_creation",
        "join_condition": "sl.host_id = sh.host_id"
    },
    
] %}

SELECT
    {% for config in configs %}
        {{ config["columns"] }}{% if not loop.last %},{% endif %}
    {% endfor %}
FROM
    {% for config in configs %}
        {% if loop.first %}
            {{ ref(config["model"]) }} AS {{ config["alias"] }}
        {% else %}
            LEFT JOIN {{ ref(config["model"]) }} AS {{ config["alias"] }}
                ON {{ config["join_condition"] }}
        {% endif %}
    {% endfor %}

