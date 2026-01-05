SELECT
    nullif([records.id], '') as record_id
    ,{{nullif_date('[records.createdTime]')}} as created_time
    ,[records.fields.InvoiceID] as invoice_nid --natural key of the table
    ,nullif([records.fields.Invoice Number], '') as invoice_number
    ,[records.fields.CustomerID] as customer_nid --foreign key to customer table
    ,{{nullif_date('[records.fields.Invoice Date]')}} as invoice_date
    ,nullif([records.fields.Payment Terms], '') as payment_terms
    ,{{nullif_date('[records.fields.Due Date]')}} as due_date
    ,nullif([records.fields.Status], '') as status
    ,nullif([offset], '') as offset
FROM {{ source('lh__airtable', 'invoice_header') }}