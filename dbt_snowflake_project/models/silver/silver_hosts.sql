{{ 
  config(
    materialized = 'incremental',
    unique_key = 'HOST_ID',
    incremental_strategy='merge',
  ) 
}}

SELECT 
    HOST_ID,
    HOST_NAME,
    HOST_SINCE,
    IS_SUPERHOST,
    {{negative_replacement('RESPONSE_RATE')}} as RESPONSE_RATE,
    CASE 
        WHEN RESPONSE_RATE>95 then 'Very Good'
        WHEN RESPONSE_RATE>80 then 'Good'
        WHEN RESPONSE_RATE>60 then 'Fair'
        ELSE 'Poor'
    END as RESPONSE_RATE_QUALITY,
    CREATED_AT,
    CURRENT_TIMESTAMP() as TRANSFORMED_AT

from {{ ref('hosts') }}

{% if is_incremental() %}

WHERE CREATED_AT > (
    SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{ this }}
)

{% endif %}
