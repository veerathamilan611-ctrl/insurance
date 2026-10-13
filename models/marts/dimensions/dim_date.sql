{{ config(materialized="table", alias="DIM_DATE") }}

with
    date_range as (
        select
            dateadd(
                day, row_number() over (order by seq4()) - 1, '2020-01-01'::date
            )::date as date_day
        from table(generator(rowcount => 2557))
    ),

    date_dimension as (
        select
            row_number() over (order by date_day) as date_key,
            date_day,
            day(date_day) as day_of_month,
            dayofweekiso(date_day) as day_of_week,
            dayname(date_day) as day_name,
            month(date_day) as month_number,
            monthname(date_day) as month_name,
            quarter(date_day) as quarter_number,
            year(date_day) as year_number,
            iff(dayofweekiso(date_day) in (6, 7), true, false) as is_weekend
        from date_range
    )

select
    -1 as date_key,
    null::date as date_day,
    null::number as day_of_month,
    null::number as day_of_week,
    'Unknown' as day_name,
    null::number as month_number,
    'Unknown' as month_name,
    null::number as quarter_number,
    null::number as year_number,
    null::boolean as is_weekend

union all

select
    date_key,
    date_day,
    day_of_month,
    day_of_week,
    day_name,
    month_number,
    month_name,
    quarter_number,
    year_number,
    is_weekend
from date_dimension
