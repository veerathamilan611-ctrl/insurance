{{ config(materialized="view") }}

with
    funnel_leads as (
        select
            lkp.marketing_channel_group,
            count(distinct f.lead_id) as total_leads,
            count(
                distinct case when f.policy_purchased = true then f.lead_id end
            ) as purchased_leads
        from {{ ref("fact_lead_funnel") }} f
        left join
            {{ ref("dim_lead_source") }} dls on f.lead_source_sk = dls.lead_source_key
        left join
            {{ ref("dim_marketing_channel_group") }} lkp
            on upper(trim(dls.lead_source)) = upper(trim(lkp.funnel_lead_source))
        group by lkp.marketing_channel_group
    ),

    campaign_spend as (
        select lkp.marketing_channel_group, sum(dc.actual_spend) as total_campaign_spend
        from {{ ref("dim_campaign") }} dc
        left join
            {{ ref("dim_marketing_channel_group") }} lkp
            on upper(trim(dc.campaign_channel)) = upper(trim(lkp.campaign_channel))
        group by lkp.marketing_channel_group
    )

select
    coalesce(
        f.marketing_channel_group, c.marketing_channel_group
    ) as marketing_channel_group,
    coalesce(f.total_leads, 0) as total_leads,
    coalesce(f.purchased_leads, 0) as purchased_leads,
    coalesce(c.total_campaign_spend, 0) as total_campaign_spend
from funnel_leads f
full outer join
    campaign_spend c on f.marketing_channel_group = c.marketing_channel_group
WHERE COALESCE(
    f.marketing_channel_group,
    c.marketing_channel_group
) IS NOT NULL