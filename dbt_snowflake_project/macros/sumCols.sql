{% macro sum_columns(columns) %}
    (
        {%- for col in columns -%}
            COALESCE({{ col }}, 0)
            {%- if not loop.last %} + {% endif -%}
        {%- endfor -%}
    )
{% endmacro %}