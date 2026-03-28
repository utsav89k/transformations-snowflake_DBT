{% set configgs=[
    {
        "table":"SNOWFLAKE_DBT.SILVER.SILVER_BOOKINGS",
        "columns":"SILVER_BOOKINGS.*",
        "alias":"SILVER_BOOKINGS"
    },
    {
        "table":"SNOWFLAKE_DBT.SILVER.SILVER_LISTINGS",
        "columns":"SILVER_LISTINGS.HOST_ID, SILVER_LISTINGS.PROPERTY_TYPE,SILVER_LISTINGS.ROOM_TYPE,SILVER_LISTINGS.CITY,SILVER_LISTINGS.COUNTRY,SILVER_LISTINGS.ACCOMMODATES,SILVER_LISTINGS.BEDROOMS,SILVER_LISTINGS.BATHROOMS,SILVER_LISTINGS.PRICE_PER_NIGHT,SILVER_LISTINGS.EXPENSIVENESS,SILVER_LISTINGS.GROUP_STATUS,SILVER_LISTINGS.CREATED_AT as LISTINGS_CREATED_AT",
        "alias":"SILVER_LISTINGS",
        "join_condition": "SILVER_BOOKINGS.listing_id=SILVER_LISTINGS.listing_id"
    },
    {
        "table":"SNOWFLAKE_DBT.SILVER.SILVER_HOSTS",
        "columns":"SILVER_HOSTS.HOST_NAME,SILVER_HOSTS.HOST_SINCE,SILVER_HOSTS.IS_SUPERHOST,SILVER_HOSTS.RESPONSE_RATE,SILVER_HOSTS.RESPONSE_RATE_QUALITY,SILVER_HOSTS.CREATED_AT as HOSTS_CREATED_AT",
        "alias":"SILVER_HOSTS",
        "join_condition":"SILVER_HOSTS.HOST_ID=SILVER_LISTINGS.HOST_ID"
    }
]
%}


SELECT
    {% for conffig in configgs %}
        {{conffig['columns']}} {%if not loop.last%} , {%endif%}
    {% endfor%}

FROM 
    {% for conffig in configgs %}
        {% if loop.first %}
            {{conffig['table']}} as {{conffig['alias']}}
        {% else %}
            LEFT JOIN {{conffig['table']}} as {{conffig['alias']}}
            ON {{conffig['join_condition']}}
        {% endif %}
    {% endfor %}