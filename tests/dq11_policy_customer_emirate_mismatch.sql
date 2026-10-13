
{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ11'}
) }}

SELECT
    p.policy_id,
    p.customer_id,
    p.emirates AS policy_emirates,
    c.emirates AS customer_emirates
FROM {{ ref('stg_policies') }} p
INNER JOIN {{ ref('stg_customers') }} c
    ON p.customer_id = c.customer_id
WHERE p.emirates IS NOT NULL
  AND c.emirates IS NOT NULL
  AND UPPER(TRIM(p.emirates)) <> UPPER(TRIM(c.emirates))