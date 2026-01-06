
WITH base AS (
    SELECT
        nullif([records.id], '') as record_id
        ,{{nullif_date('[records.createdTime]')}} as created_time
        ,[records.fields.Customer ID] as customer_nid --natural key of the table
        ,nullif([records.fields.Customer Name], '') as customer_name
        ,nullif([records.fields.Customer City], '') as customer_city
        ,nullif([records.fields.Customer County/Region], '') as customer_region
        ,nullif([records.fields.Customer Zip Code], '') as customer_zip_code
        ,nullif([records.fields.Customer State], '') as customer_state
        ,nullif([offset], '') as offset
    FROM {{ source('lh__airtable', 'customers') }}
)
SELECT
    record_id
    ,created_time
    ,customer_nid
    ,customer_name
    ,customer_city
    ,customer_region
    ,CASE WHEN customer_zip_code IS NULL then 'Unknown' ELSE customer_zip_code END as customer_zip_code
    ,customer_state
    ,offset
FROM base