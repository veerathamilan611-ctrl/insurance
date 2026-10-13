
{{ config(
    severity = 'warn',
    store_failures = true,
    meta = {'dq_rule_id': 'DQ32'}
) }}

SELECT
    f.LEADID AS lead_id,
    f.CHANNEL AS funnel_channel
FROM {{ source('insurancemarket', 'conversionfunnel') }} AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM {{ source('insurancemarket', 'campaigns') }} AS c
    WHERE TRIM(LOWER(c.CHANNEL)) = TRIM(LOWER(f.CHANNEL))
)