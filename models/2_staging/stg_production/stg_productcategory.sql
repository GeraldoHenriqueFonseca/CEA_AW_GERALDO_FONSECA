with
    product_category as (
        select 
            productcategoryid as product_category_id
            , name as product_category
            , modifieddate as modified_date  
        from {{ source('stg_production','productcategory') }}
    )

select *
from product_category