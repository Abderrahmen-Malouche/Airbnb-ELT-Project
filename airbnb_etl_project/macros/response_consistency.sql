{% macro response_consistency(column_name) %}
    CASE
        WHEN {{ column_name }} >= 90 THEN 'consistent'
        WHEN {{ column_name }} >= 50 THEN 'average'
        WHEN {{ column_name }} > 0 THEN 'inconsistent'
        ELSE 'none'
    END
{% endmacro %}
