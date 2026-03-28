{% macro greaterweek(column_name, threshold) %}
    CASE
        WHEN {{ column_name }} > {{ threshold }} THEN 'Less than a Week'
        ELSE 'More than a Week'
    END
{% endmacro %}