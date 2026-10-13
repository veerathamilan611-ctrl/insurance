{{ config(materialized="table", alias="DIM_SALES_CHANNEL") }}

with
    sales_channels as (

        select distinct sales_channel
        from {{ ref("stg_policies") }}
        where sales_channel is not null

    ),

    sales_channel_dimension as (

        select
            row_number() over (order by sales_channel) as sales_channel_key,

            sales_channel

        from sales_channels

    )

select -1 as sales_channel_key, 'Unknown' as sales_channel

union all

select sales_channel_key, sales_channel
from sales_channel_dimension
