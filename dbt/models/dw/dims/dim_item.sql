SELECT
    {{dbt_utils.generate_surrogate_key(['item_nid'])}} as item_sid_hash
    ,item_nid
    ,item_category
    ,item_sub_category
    ,item_commodity
    ,item_commodity_detail
FROM {{ref('item')}}