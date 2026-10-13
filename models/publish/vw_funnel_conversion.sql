{{ config(materialized="view") }}

select
    f.lead_id,
    f.quote_date,
    f.product_type,
    f.channel as sales_channel,
    f.lead_source,

    f.stage1_form_submitted,
    f.stage1_date,
    f.stage2_options_reviewed,
    f.stage2_date,
    f.advisor_consulted,
    f.stage3_documents_uploaded,
    f.stage3_date,
    f.policy_purchased,
    f.purchase_date,

    f.derived_drop_off_stage,
    f.cleaned_drop_off_reason,

    f.dq_stage_sequence_flag,
    f.dq_stage_date_sequence_flag,
    f.dq_missing_drop_off_reason_flag

from {{ ref("fact_lead_funnel") }} f
