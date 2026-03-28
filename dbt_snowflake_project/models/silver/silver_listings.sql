{{ 
  config(
    materialized = 'incremental',
    unique_key = 'LISTING_ID',
    incremental_strategy='merge',
  ) 
}}

SELECT 
    LISTING_ID,
    HOST_ID,
    PROPERTY_TYPE,
    ROOM_TYPE,
    CITY,
    COUNTRY,
    ACCOMMODATES,
    BEDROOMS,
    BATHROOMS,
    {{negative_replacement('PRICE_PER_NIGHT')}} as PRICE_PER_NIGHT,
    {{price_category('PRICE_PER_NIGHT')}} as EXPENSIVENESS,
    {{family_status('ACCOMMODATES')}} as GROUP_STATUS,
    CREATED_AT,
    CURRENT_TIMESTAMP() as TRANSFORMED_AT

from {{ ref('listings') }}

{% if is_incremental() %}

WHERE CREATED_AT > (
    SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{ this }}
)

{% endif %}
