{{ config(materialized="view", schema="INTERMEDIATE") }}

{% set as_of_date = var("as_of_date", run_started_at.strftime("%Y-%m-%d")) %}

with
    policies as (select * from {{ ref("stg_policies") }}),

    derived as (

        select
            policy_id,
            customer_id,
            product_type,
            insurance_partner,
            premium_amount,
            policy_status,
            issue_date,
            expiry_date,
            sales_channel,
            emirates,

            coalesce(advisor_id, '-1') as advisor_id,

            _ingested_ts,
            _source_file_name,

            to_date('{{ as_of_date }}') as as_of_date,

            case
                when upper(policy_status) = 'CANCELLED'
                then 'Cancelled'
                when expiry_date < to_date('{{ as_of_date }}')
                then 'Expired'
                when issue_date > to_date('{{ as_of_date }}')
                then 'Not Yet Effective'
                else 'Active'
            end as derived_policy_status,

            customer_id is null as dq_missing_customer,

            advisor_id is null as dq_missing_advisor,

            issue_date is null or expiry_date is null as dq_invalid_dates,

            premium_amount is null or premium_amount <= 0 as dq_invalid_premium,

            issue_date is not null
            and expiry_date is not null
            and expiry_date < issue_date as dq_expiry_before_issue

        from policies

    )

select *
from derived
