{{ 
  config(
    materialized = 'incremental',
    unique_key = 'LISTING_ID',
    incremental_strategy='merge',
  ) 
}}
SELECT
    LISTING_ID,
    PROPERTY_TYPE,
    ROOM_TYPE,
    CITY,
    COUNTRY,
    EXPENSIVENESS,
    GROUP_STATUS,
    CREATED_AT,
    TRANSFORMED_AT

FROM
    {{ ref('silver_listings') }}

{% if is_incremental() %}
WHERE TRANSFORMED_AT > (
    SELECT COALESCE(MAX(TRANSFORMED_AT), '1900-01-01'::timestamp)
    FROM {{ this }}
)
{% endif %}