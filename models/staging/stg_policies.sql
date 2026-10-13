{{ config(
    materialized='view',
    schema='STAGE'
) }}

with source as (

    select *
    from {{ source('insurancemarket', 'policies') }}

),

renamed as (

    select
        nullif(trim(POLICYID), '') as policy_id,
        nullif(trim(CUSTOMERID), '') as customer_id,
        initcap(nullif(trim(PRODUCTTYPE), '')) as product_type,
        nullif(trim(INSURANCEPARTNER), '') as insurance_partner,

        try_to_number(
            nullif(trim(PREMIUMAMOUNT), '')
        ) as premium_amount,

        upper(nullif(trim(POLICYSTATUS), '')) as policy_status,

        try_to_date(
            nullif(trim(ISSUEDATE), '')
        ) as issue_date,

        try_to_date(
            nullif(trim(EXPIRYDATE), '')
        ) as expiry_date,

        upper(nullif(trim(SALESCHANNEL), '')) as sales_channel,
        initcap(nullif(trim(EMIRATES), '')) as emirates,
        nullif(trim(ADVISORID), '') as advisor_id,

        _INGESTED_TS,
        _SOURCE_FILE_NAME

    from source

)

select *
from renamed