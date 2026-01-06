SELECT
    {{dbt_utils.generate_surrogate_key(['invoice_nid'])}} as invoice_sid_hash
    ,invoice_nid
    ,invoice_number
    ,payment_terms
    ,status
FROM {{ref('invoice_header')}}