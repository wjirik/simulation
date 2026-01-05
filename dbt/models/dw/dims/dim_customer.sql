SELECT
    {{dbt_utils.generate_surrogate_key(['customer_nid'])}} as customer_sid_hash
    ,customer_nid
    ,customer_name
    ,customer_city
    ,customer_region
    ,customer_zip_code
    ,customer_state
FROM {{ref('customer')}}