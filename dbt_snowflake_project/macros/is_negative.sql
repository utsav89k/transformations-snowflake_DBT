{% macro negative_replacement(column_name) %}
    CASE 
        WHEN {{ column_name }} < 0 THEN 0
        ELSE {{ column_name }}
    END
{% endmacro %}