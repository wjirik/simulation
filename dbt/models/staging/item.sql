SELECT
    nullif([records.id], '') as record_id
    ,{{nullif_date('[records.createdTime]')}} as created_time
    ,[records.fields.ItemID] as item_nid --foreign key to the item table
    ,nullif([records.fields.Category], '') as item_category
    ,nullif([records.fields.Sub Category], '') as item_sub_category
    ,nullif([records.fields.Commodity], '') as item_commodity
    ,nullif([records.fields.Commodity Detail], '') as item_commodity_detail
    ,nullif([offset], '') as offset
FROM {{ source('lh__airtable', 'item') }}