SELECT
    coalesce(di.invoice_sid_hash, '-1') as invoice_sid_hash
    ,coalesce(ditem.item_sid_hash, '-1') as item_sid_hash
    ,coalesce(dc.customer_sid_hash, '-1') as customer_sid_hash

    ,ih.invoice_date
    ,ih.due_date
    ,il.invoice_line_id
    ,CONCAT(ih.invoice_number, ' - ', il.invoice_line_id) as invoice_document_line
    ,il.quantity
    ,il.price
    ,(il.quantity * il.price) as amount

FROM {{ref('invoice_line')}} il
LEFT JOIN {{ref('dim_invoice')}} di
    ON il.invoice_nid = di.invoice_nid
LEFT JOIN {{ref('dim_item')}} ditem
    ON il.item_nid = ditem.item_nid
LEFT JOIN {{ref('invoice_header')}} ih
    ON il.invoice_nid = ih.invoice_nid
LEFT JOIN {{ref('dim_customer')}} dc
    ON ih.customer_nid = dc.customer_nid
