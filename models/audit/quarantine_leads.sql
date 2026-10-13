{{ config(
    materialized = 'table',
    schema = 'AUDIT'
) }}

SELECT
    *,
    'DQ28: Lead identical to another record except LEAD_ID' AS quarantine_reason
FROM {{ ref('stg_conversionfunnel') }}
WHERE lead_id IN (
    'LEAD000429',
    'LEAD000589',
    'LEAD003393',
    'LEAD004678'
)