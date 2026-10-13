{{ config(materialized="table") }}

with
    customers as (

        select
            customer_id,
            customer_name,
            age,
            gender,
            emirates,
            customer_segment,
            registration_date,
            my_alfred_member,
            customer_rating
        from {{ ref("stg_customers") }}

    ),

    customer_dimension as (

        select
            row_number() over (order by customer_id) as customer_key,

            customer_id,
            customer_name,
            age,
            gender,
            emirates,
            customer_segment,
            registration_date,
            my_alfred_member,
            customer_rating

        from customers

    )

select
    -1 as customer_key,
    'UNKNOWN' as customer_id,
    'Unknown' as customer_name,
    null as age,
    'Unknown' as gender,
    'Unknown' as emirates,
    'Unknown' as customer_segment,
    null as registration_date,
    false as my_alfred_member,
    null as customer_rating

union all

select
    customer_key,
    customer_id,
    customer_name,
    age,
    gender,
    emirates,
    customer_segment,
    registration_date,
    my_alfred_member,
    customer_rating
from customer_dimension
