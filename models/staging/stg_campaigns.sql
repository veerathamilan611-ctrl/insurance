{{ config(materialized="view", schema="STAGE") }}

with
    source as (select * from {{ source("insurancemarket", "campaigns") }}),

    renamed as (

        select
            nullif(trim(campaignid), '') as campaign_id,
            nullif(trim(campaignname), '') as campaign_name,
            upper(nullif(trim(channel), '')) as channel,

            try_to_date(nullif(trim(startdate), '')) as start_date,

            try_to_date(nullif(trim(enddate), '')) as end_date,

            try_to_number(nullif(trim(budget), '')) as budget,

            try_to_number(nullif(trim(actualspend), '')) as actual_spend,

            try_to_number(nullif(trim(leadsgenerated), '')) as leads_generated,

            try_to_number(nullif(trim(conversions), '')) as conversions,

            try_to_number(nullif(trim(impressions), '')) as impressions,

            try_to_number(nullif(trim(clicks), '')) as clicks,

            _ingested_ts,
            _source_file_name

        from source

    )

select *
from renamed
