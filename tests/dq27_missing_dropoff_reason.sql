{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ27'}
) }}

SELECT
    lead_id,
    drop_off_reason
FROM {{ ref('int_leads') }}
WHERE policy_purchased = FALSE
  AND (
      drop_off_reason IS NULL
      OR TRIM(drop_off_reason) = ''
  )