{{ 
  config(
    materialized = 'incremental',
    unique_key = 'BOOKING_ID',
    incremental_strategy='merge',
  ) 
}}

-- Incremental Helps to Load the incremental Data , and unique key to perform the upsert operation

SELECT 
    BOOKING_ID,
    LISTING_ID,
    BOOKING_DATE,
    NIGHTS_BOOKED,
    BOOKING_AMOUNT,
    {{negative_replacement('CLEANING_FEE')}} as CLEANING_FEE,
    {{negative_replacement('SERVICE_FEE')}} as SERVICE_FEE,
    BOOKING_STATUS,
    {{sum_columns(['CLEANING_FEE','SERVICE_FEE','BOOKING_AMOUNT'])}} as TOTAL_CHARGE,
    {{greaterweek('NIGHTS_BOOKED',7)}} as WEEK_STATUS,
     CREATED_AT,
     CURRENT_TIMESTAMP() as TRANSFORMED_AT

from {{ ref('bookings') }}

{% if is_incremental() %}

WHERE BOOKING_DATE > (
    SELECT COALESCE(MAX(BOOKING_DATE), '1900-01-01') FROM {{ this }}
)

{% endif %}