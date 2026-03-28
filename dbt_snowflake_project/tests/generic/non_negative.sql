{% test check_non_negative(model, column_name) %}

    select *
    from {{ model }}
    where {{ column_name }} is null

{% endtest %}