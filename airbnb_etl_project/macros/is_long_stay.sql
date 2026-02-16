{% macro is_long_stay(column_name,min_nights=7)%}
  {{column_name}}>={{min_nights}}
{% endmacro %}