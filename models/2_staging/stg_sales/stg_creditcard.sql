with
    credit_card as (
        select 
            creditcardid as credit_card_id
            , cardtype as  card_type
            , modifieddate as modified_date
        from {{ source('stg_sales', 'creditcard') }}
    )

select *
from credit_card 