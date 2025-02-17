{{ config(materialized='table') }}

with
    dim_credit_card as (
        select
            {{ dbt_utils.generate_surrogate_key(['credit_card_id', 'card_type']) }} as sk_credit_card
            , *
        from {{ ref('int_credit_details') }}
    )

select *
from dim_credit_card