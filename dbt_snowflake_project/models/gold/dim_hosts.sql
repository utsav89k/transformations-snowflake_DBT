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
    RESPONSE_RATE_QUALITY,
    CREATED_AT,
    TRANSFORMED_AT
FROM {{ ref('silver_hosts') }}

{% if is_incremental() %}
WHERE TRANSFORMED_AT > (
    SELECT COALESCE(MAX(TRANSFORMED_AT), '1900-01-01'::timestamp)
    FROM {{ this }}
)
{% endif %}