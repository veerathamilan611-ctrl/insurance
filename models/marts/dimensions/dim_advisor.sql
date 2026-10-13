{{ config(materialized="table", alias="DIM_ADVISOR") }}

with
    advisors as (

        select
            advisor_id, advisor_name, team, join_date, target_policies, target_revenue
        from {{ ref("stg_advisors") }}

    ),

    advisor_dimension as (

        select
            row_number() over (order by advisor_id) as advisor_key,

            advisor_id,
            advisor_name,
            team,
            join_date,
            target_policies,
            target_revenue

        from advisors

    )

select
    -1 as advisor_key,
    'UNKNOWN' as advisor_id,
    'Unknown' as advisor_name,
    'Unknown' as team,
    null as join_date,
    null as target_policies,
    null as target_revenue

union all

select
    advisor_key,
    advisor_id,
    advisor_name,
    team,
    join_date,
    target_policies,
    target_revenue
from advisor_dimension
