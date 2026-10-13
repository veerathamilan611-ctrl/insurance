{{ config(materialized="table") }}

select distinct
    nullif(trim(funnel_lead_source), '') as funnel_lead_source,
    nullif(trim(campaign_channel), '') as campaign_channel,
    marketing_channel_group as marketing_channel_group
from {{ source("marketing_lookup", "lkp_marketing_channel_group") }}
