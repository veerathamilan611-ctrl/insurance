{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ28'}
) }}

SELECT *
FROM {{ ref('stg_conversionfunnel') }}
QUALIFY COUNT(*) OVER (
    PARTITION BY
        quote_date,
        product_type,
        channel,
        lead_source,
        stage1_form_submitted,
        stage1_date,
        stage2_options_reviewed,
        stage2_date,
        advisor_consulted,
        stage3_documents_uploaded,
        stage3_date,
        policy_purchased,
        purchase_date,
        drop_off_reason
) > 1