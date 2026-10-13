{{ config(materialized="view", schema="STAGE") }}

with source as (

    select *
    from {{ source("insurancemarket", "customers") }}

),

renamed as (

    select
        trim(customerid) as customer_id,
        trim(customername) as customer_name,
        try_to_number(nullif(trim(age), '')) as age,
        upper(trim(gender)) as gender,
        nullif(trim(emirates), '') as emirates,
        nullif(trim(customersegment), '') as customer_segment,

        try_to_date(
            nullif(trim(registrationdate), '')
        ) as registration_date,

        case
            when upper(trim(myalfredmember)) = 'YES' then true
            when upper(trim(myalfredmember)) = 'NO' then false
            else null
        end as my_alfred_member,

        try_to_number(
            nullif(trim(customerrating), '')
        ) as customer_rating,

        _ingested_ts,
        _source_file_name

    from source

)

select *
from renamed