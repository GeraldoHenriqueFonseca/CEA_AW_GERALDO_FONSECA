with
    product_subcategory as (
        select
            productsubcategoryid as product_subcategory_id
            , productcategoryid as product_category_id
            , name as product_subcategory
            , modifieddate as modified_date
        from {{ source('stg_production', 'productsubcategory') }}
    )

select *
from product_subcategory