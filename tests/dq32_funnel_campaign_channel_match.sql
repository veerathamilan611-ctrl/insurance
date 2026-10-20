{{ config(severity="warn", store_failures=true, meta={"dq_rule_id": "DQ32"}) }}

select f.leadid as lead_id, f.leadsource as lead_source, f.channel as sales_channel
from {{ source("insurancemarket", "conversionfunnel") }} as f
where nullif(trim(f.leadid), '') is null
