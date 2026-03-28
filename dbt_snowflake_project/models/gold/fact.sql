{{ 
    config(
        materialized = 'incremental'
    ) 
}}

    SELECT
        b.BOOKING_ID,
        b.LISTING_ID,
        b.NIGHTS_BOOKED,
        b.BOOKING_AMOUNT,
        b.CLEANING_FEE,
        b.SERVICE_FEE,
        b.TOTAL_CHARGE,
        l.HOST_ID,
        l.BEDROOMS,
        l.BATHROOMS,
        l.PRICE_PER_NIGHT,
        h.RESPONSE_RATE,
        b.CREATED_AT,
        b.TRANSFORMED_AT
    FROM SNOWFLAKE_DBT.SILVER.silver_bookings b
    left join SNOWFLAKE_DBT.SILVER.silver_listings l
    on l.listing_id=b.listing_id
    left join SNOWFLAKE_DBT.SILVER.silver_hosts h
    on h.host_id=l.host_id

    {% if is_incremental() %}
        WHERE b.CREATED_AT > (
            SELECT COALESCE(MAX(CREATED_AT), '1900-01-01')
            FROM {{ this }}
        )
    {% endif %}

