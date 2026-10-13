
{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ16'}
) }}

SELECT
    policy_id,
    customer_id,
    product_type,
    issue_date
FROM {{ ref('stg_policies') }}
WHERE (customer_id, product_type, issue_date) IN (
    SELECT
        customer_id,
        product_type,
        issue_date
    FROM {{ ref('stg_policies') }}
    GROUP BY
        customer_id,
        product_type,
        issue_date
    HAVING COUNT(*) > 1
)