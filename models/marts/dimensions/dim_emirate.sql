{{ config(materialized="table", alias="DIM_EMIRATE") }}

with
    emirates as (

        select distinct trim(emirates) as emirate_name
        from {{ ref("stg_policies") }}
        where emirates is not null and trim(emirates) != ''

    ),

    emirate_dimension as (

        select row_number() over (order by emirate_name) as emirate_key, emirate_name

        from emirates

    )

select -1 as emirate_key, 'Unknown' as emirate_name

union all

select emirate_key, emirate_name
from emirate_dimension
