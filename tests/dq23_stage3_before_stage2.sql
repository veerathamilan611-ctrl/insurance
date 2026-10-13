{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ23'}
) }}

SELECT
    lead_id,
    stage2_date,
    stage3_date
FROM {{ ref('int_leads') }}
WHERE stage2_date IS NOT NULL
  AND stage3_date IS NOT NULL
  AND stage3_date < stage2_date