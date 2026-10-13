{{ config(materialized="table", alias="FACT_LEAD_FUNNEL") }}

with leads as (select * from {{ ref("int_leads") }})

select
    -- Grain: one row per cleaned lead
    l.lead_id,

    -- Dimension foreign keys
    coalesce(dls.lead_source_key, -1) as lead_source_sk,
    coalesce(dp.product_key, -1) as product_sk,
    coalesce(dsc.sales_channel_key, -1) as sales_channel_sk,

    coalesce(dd_quote.date_key, -1) as quote_date_sk,
    coalesce(dd_stage1.date_key, -1) as stage1_date_sk,
    coalesce(dd_stage2.date_key, -1) as stage2_date_sk,
    coalesce(dd_stage3.date_key, -1) as stage3_date_sk,
    coalesce(dd_purchase.date_key, -1) as purchase_date_sk,

    -- Lead details
    l.quote_date,
    l.product_type,
    l.channel,
    l.lead_source,

    -- Funnel stages
    l.stage1_form_submitted,
    l.stage1_date,
    l.stage2_options_reviewed,
    l.stage2_date,
    l.advisor_consulted,
    l.stage3_documents_uploaded,
    l.stage3_date,
    l.policy_purchased,
    l.purchase_date,

    -- Drop-off information
    l.drop_off_reason,
    l.cleaned_drop_off_reason,
    l.has_drop_off_reason,
    l.derived_drop_off_stage,

    -- Data quality flags
    iff(
        coalesce(l.dq_stage_date_sequence_invalid, false), 1, 0
    ) as dq_stage_sequence_flag,

    iff(
        coalesce(l.dq_stage_date_sequence_invalid, false), 1, 0
    ) as dq_stage_date_sequence_flag,

    iff(
        coalesce(l.dq_missing_drop_off_reason, false), 1, 0
    ) as dq_missing_drop_off_reason_flag

from leads l

-- Lead source dimension
left join
    {{ ref("dim_lead_source") }} dls
    on upper(trim(l.lead_source)) = upper(trim(dls.lead_source))

-- Product dimension
left join
    {{ ref("dim_product") }} dp
    on upper(trim(l.product_type)) = upper(trim(dp.product_type))

-- Sales channel dimension
left join
    {{ ref("dim_sales_channel") }} dsc
    on upper(trim(l.channel)) = upper(trim(dsc.sales_channel))

-- Quote date
left join {{ ref("dim_date") }} dd_quote on l.quote_date = dd_quote.date_day

-- Stage 1 date
left join {{ ref("dim_date") }} dd_stage1 on l.stage1_date = dd_stage1.date_day

-- Stage 2 date
left join {{ ref("dim_date") }} dd_stage2 on l.stage2_date = dd_stage2.date_day

-- Stage 3 date
left join {{ ref("dim_date") }} dd_stage3 on l.stage3_date = dd_stage3.date_day

-- Purchase date
left join {{ ref("dim_date") }} dd_purchase on l.purchase_date = dd_purchase.date_day
