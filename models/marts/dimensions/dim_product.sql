{{ config(materialized="table", alias="DIM_PRODUCT") }}

with
    products as (

        select distinct product_type
        from {{ ref("stg_policies") }}
        where product_type is not null

    ),

    product_dimension as (

        select row_number() over (order by product_type) as product_key, product_type

        from products

    )

select -1 as product_key, 'Unknown' as product_type

union all

select product_key, product_type
from product_dimension
