SELECT
    nullif([records.id], '') as record_id
    ,{{nullif_date('[records.createdTime]')}} as created_time
    ,[records.fields.InvoiceID] as invoice_nid --foreign key to invoice_header table
    ,[records.fields.ItemID] as item_nid --foreign key to item table
    ,[records.fields.LineID] as invoice_line_id --natural key of the table
    ,CAST([records.fields.Quantity] as decimal(18,4)) as quantity
    ,CAST([records.fields.Price] as decimal(18,4)) as price
    ,nullif([offset], '') as offset
FROM {{ source('lh__airtable', 'invoice_line') }}