{{ config(materialized="view") }}

select
    f.policy_id,
    f.customer_sk,
    c.customer_id,
    c.customer_name,
    c.customer_segment,

    f.advisor_sk,
    a.advisor_id,
    a.advisor_name,
    a.team as advisor_team,

    p.product_type as product_name,
    pt.insurance_partner as partner_name,
    sc.sales_channel as sales_channel_name,
    e.emirate_name,

    f.premium_amount,
    f.issue_date_sk,
    f.expiry_date_sk

from {{ ref("fact_policy") }} f

left join {{ ref("dim_customer") }} c on f.customer_sk = c.customer_key

left join {{ ref("dim_advisor") }} a on f.advisor_sk = a.advisor_key

left join {{ ref("dim_product") }} p on f.product_sk = p.product_key

left join {{ ref("dim_partner") }} pt on f.partner_sk = pt.partner_key

left join {{ ref("dim_sales_channel") }} sc on f.sales_channel_sk = sc.sales_channel_key

left join {{ ref("dim_emirate") }} e on f.emirate_sk = e.emirate_key
