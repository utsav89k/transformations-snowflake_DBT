select * from {{ source('SOURCE_DATA', 'listings') }}
where BEDROOMS<0 or BATHROOMS<0