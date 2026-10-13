{{ config(materialized="table", alias="DIM_CAMPAIGN") }}

with
    campaign_source as (
        select
            trim(campaignid) as campaign_id,
            trim(campaignname) as campaign_name,
            trim(channel) as campaign_channel,
            startdate as start_date,
            enddate as end_date,
            budget,
            actualspend as actual_spend,
            leadsgenerated as leads_generated,
            conversions,
            impressions,
            clicks
        from {{ source("insurancemarket", "campaigns") }}
        where campaignid is not null
    ),

    campaign_dimension as (
        select
            row_number() over (order by campaign_id) as campaign_key,
            campaign_id,
            campaign_name,
            campaign_channel,
            start_date,
            end_date,
            budget,
            actual_spend,
            leads_generated,
            conversions,
            impressions,
            clicks
        from campaign_source
    )

select
    -1 as campaign_key,
    'UNKNOWN' as campaign_id,
    'Unknown' as campaign_name,
    'Unknown' as campaign_channel,
    null as start_date,
    null as end_date,
    null as budget,
    null as actual_spend,
    null as leads_generated,
    null as conversions,
    null as impressions,
    null as clicks

union all

select
    campaign_key,
    campaign_id,
    campaign_name,
    campaign_channel,
    start_date,
    end_date,
    budget,
    actual_spend,
    leads_generated,
    conversions,
    impressions,
    clicks
from campaign_dimension
