with
    product as (
        select
            productid as product_id
            , productsubcategoryid as product_subcategory_id
            , name as product_name
            , listprice as list_price
            , modifieddate as modified_date
        from {{ source('stg_production','product') }}
    )

select *
from  product