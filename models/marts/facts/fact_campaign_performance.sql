{{ config(materialized="table", alias="FACT_CAMPAIGN_PERFORMANCE") }}

with campaigns as (select * from {{ ref("stg_campaigns") }})

select
    -- Campaign grain: one row per campaign
    c.campaign_id,

    -- Dimension foreign keys
    coalesce(dc.campaign_key, -1) as campaign_sk,
    coalesce(dd_start.date_key, -1) as start_date_sk,
    coalesce(dd_end.date_key, -1) as end_date_sk,

    -- Campaign details
    c.campaign_name,
    c.channel,
    c.start_date,
    c.end_date,

    -- Campaign measures
    c.budget,
    c.actual_spend,
    c.leads_generated,
    c.conversions,
    c.impressions,
    c.clicks,

    -- Calculated performance metrics
    c.actual_spend / nullif(c.leads_generated, 0) as cost_per_lead,

    c.actual_spend / nullif(c.conversions, 0) as cost_per_conversion,

    c.actual_spend / nullif(c.budget, 0) * 100 as budget_utilisation_pct

from campaigns c

left join {{ ref("dim_campaign") }} dc on trim(c.campaign_id) = trim(dc.campaign_id)

left join {{ ref("dim_date") }} dd_start on c.start_date = dd_start.date_day

left join {{ ref("dim_date") }} dd_end on c.end_date = dd_end.date_day
