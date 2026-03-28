{{ 
  config(
    materialized = 'incremental',
    unique_key = 'BOOKING_ID',
    incremental_strategy='merge',
  ) 
}}
select 
        BOOKING_ID,
        BOOKING_DATE,
        CREATED_AT,
        TRANSFORMED_AT
from {{ ref('silver_bookings') }}  

{% if is_incremental() %}
WHERE TRANSFORMED_AT > (
    SELECT COALESCE(MAX(TRANSFORMED_AT), '1900-01-01'::timestamp)
    FROM {{ this }}
)
{% endif %}