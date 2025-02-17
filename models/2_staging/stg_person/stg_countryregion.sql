with
    country_region as (
        select
            countryregioncode as country_region_code
            , name as country_name
            , modifieddate as modified_date
        from {{ source('stg_person','countryregion') }}         
    )

select *
from country_region