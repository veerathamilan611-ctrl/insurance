{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ24'}
) }}

SELECT
    lead_id,
    stage3_date,
    purchase_date
FROM {{ ref('int_leads') }}
WHERE stage3_date IS NOT NULL
  AND purchase_date IS NOT NULL
  AND purchase_date < stage3_date