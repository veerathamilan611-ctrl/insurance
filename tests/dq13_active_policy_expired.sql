
{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ13'}
) }}

SELECT
    policy_id,
    policy_status,
    expiry_date
FROM {{ ref('stg_policies') }}
WHERE UPPER(TRIM(policy_status)) = 'ACTIVE'
  AND expiry_date < CURRENT_DATE()