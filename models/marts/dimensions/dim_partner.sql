{{ config(materialized="table", alias="DIM_PARTNER") }}

with
    partners as (

        select distinct insurance_partner
        from {{ ref("stg_policies") }}
        where insurance_partner is not null

    ),

    partner_dimension as (

        select
            row_number() over (order by insurance_partner) as partner_key,

            insurance_partner

        from partners

    )

select -1 as partner_key, 'Unknown' as insurance_partner

union all

select partner_key, insurance_partner
from partner_dimension
