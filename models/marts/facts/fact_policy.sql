{{ config(materialized="table", alias="FACT_POLICY") }}

with policies as (select * from {{ ref("stg_policies") }})

select
    p.policy_id,

    coalesce(dc.customer_key, -1) as customer_sk,
    coalesce(da.advisor_key, -1) as advisor_sk,
    coalesce(dp.product_key, -1) as product_sk,
    coalesce(dpa.partner_key, -1) as partner_sk,
    coalesce(dsc.sales_channel_key, -1) as sales_channel_sk,
    coalesce(de.emirate_key, -1) as emirate_sk,
    coalesce(dd_issue.date_key, -1) as issue_date_sk,
    coalesce(dd_expiry.date_key, -1) as expiry_date_sk,

    p.premium_amount,
    p.policy_status,
    p.issue_date,
    p.expiry_date

from policies p

left join {{ ref("dim_customer") }} dc on p.customer_id = dc.customer_id

left join {{ ref("dim_advisor") }} da on p.advisor_id = da.advisor_id

left join {{ ref("dim_product") }} dp on p.product_type = dp.product_type

left join {{ ref("dim_partner") }} dpa on p.insurance_partner = dpa.insurance_partner

left join
    {{ ref("dim_sales_channel") }} dsc
    on upper(trim(p.sales_channel)) = upper(trim(dsc.sales_channel))

left join
    {{ ref("dim_emirate") }} de
    on upper(trim(p.emirates)) = upper(trim(de.emirate_name))

left join {{ ref("dim_date") }} dd_issue on p.issue_date = dd_issue.date_day

left join {{ ref("dim_date") }} dd_expiry on p.expiry_date = dd_expiry.date_day
