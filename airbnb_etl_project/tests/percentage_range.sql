{% test percentage_range(model, column_name, min_value=0, max_value=100) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} < {{ min_value }}
   OR {{ column_name }} > {{ max_value }}

{% endtest %}
