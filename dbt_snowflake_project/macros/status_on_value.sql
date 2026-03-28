{% macro price_category(column_name) %}
    CASE
        WHEN {{ column_name }} < 100 THEN 'Low'
        WHEN {{ column_name }} < 200 THEN 'Medium'
        ELSE 'High'
    END
{% endmacro %}


{% macro family_status(column_name) %}
    CASE
        WHEN {{ column_name }} <= 1 THEN 'Single'
        WHEN {{ column_name }} = 2 THEN 'Couple'
        ELSE 'Family'
    END
{% endmacro %}