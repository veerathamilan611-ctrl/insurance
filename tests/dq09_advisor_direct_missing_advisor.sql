
{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ09'}
) }}

SELECT
    policy_id,
    sales_channel,
    advisor_id
FROM {{ ref('stg_policies') }}
WHERE UPPER(TRIM(sales_channel)) = 'ADVISOR DIRECT'
  AND advisor_id IS NULL