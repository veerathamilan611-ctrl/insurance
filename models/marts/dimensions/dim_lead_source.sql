{{ config(materialized="table", alias="DIM_LEAD_SOURCE") }}

with
    lead_sources as (

        select distinct trim(lead_source) as lead_source
        from {{ ref("stg_conversionfunnel") }}
        where lead_source is not null and trim(lead_source) != ''

    ),

    lead_source_dimension as (

        select row_number() over (order by lead_source) as lead_source_key, lead_source

        from lead_sources

    )

select -1 as lead_source_key, 'Unknown' as lead_source

union all

select lead_source_key, lead_source
from lead_source_dimension
