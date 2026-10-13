{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ25'}
) }}

SELECT
    lead_id,
    stage2_date,
    purchase_date
FROM {{ ref('int_leads') }}
WHERE stage2_date IS NOT NULL
  AND purchase_date IS NOT NULL
  AND purchase_date < stage2_date