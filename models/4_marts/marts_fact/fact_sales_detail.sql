{{ config(materialized= 'table') }}

with
    
    dim_product as (
        select 
            *
        from {{ ref('dim_product')}}   
    )

    , fact_sales_detail as (
        select
            s.salesorderid as sales_order_id
            , dp.sk_product as fk_product
            , dp.productid as product_id
            , dp.product_name
            , s.orderqty as order_qty
            , s.unitprice as unit_price
            , s.unitpricediscount as unit_price_discount
            , s.linetotal
        from {{ ref('stg_orderdetail')}} as s
        left join dim_product dp
        on s.productid = dp.productid
    ) 

select *
from fact_sales_detail