{{ config(materialized= 'table') }}

with

    dim_region as (
        select
            *
        from {{ ref('dim_region') }}
    )

    , dim_credit_card as (
        select
            *
        from {{ ref('dim_credit_card') }}
    )

    , dim_customers as (
        select
            *
        from {{ ref('dim_customers') }}
    )

    , dim_reason as (
        select
            *
        from {{ ref('dim_reason') }} 
    )
    
    , dim_calendar as (
        select
            *
        from {{ ref('dim_calendar') }}
    )

    , fact_sales_header as (
        select 
            salesheader.salesorderid as sales_order_id
            , dim_region.sk_region as fk_region
            , dim_credit_card.sk_credit_card as fk_credit_card
            , dim_customers.sk_customer as fk_customer
            , dim_calendar.sk_calendar as fk_calendar
            , ifnull(dim_reason.promotion_names_agg, 'não informado') as reason_agg
            , dim_reason.reason_types_agg as reason_types_agg
            , salesheader.orderdate as order_date
            , salesheader.duedate  as due_date
            , salesheader.shipdate as ship_date
            , case
                when salesheader.status = 1 then 'Em processo'
                when salesheader.status = 2 then 'Aprovado'
                when salesheader.status = 3 then 'Em falta'
                when salesheader.status = 4 then 'Rejeitado'
                when salesheader.status = 5 then 'Enviado'
                when salesheader.status = 6 then 'Cancelado'
            end as order_status
            , case
                when salesheader.onlineorderflag = true then 'Online'
                when salesheader.onlineorderflag = false then 'Físico'
            end as sales_channel
            , salesheader.subtotal
            , salesheader.taxamt as tax_amount
            , salesheader.freight
            , salesheader.totaldue as total_due
        from {{ ref('stg_orderheader') }} as salesheader
        left join dim_region
            on salesheader.bill_toaddress_id = dim_region.address_id
        left join dim_credit_card 
            on salesheader.credit_card_id = dim_credit_card.credit_card_id
        left join dim_customers
            on salesheader.customer_id = dim_customers.customer_id
        left join dim_calendar
            on salesheader.order_date = dim_calendar.date_day
        left join dim_reason
            on salesheader.sales_order_id = dim_reason.sales_order_id
    )

select *
from fact_sales_header