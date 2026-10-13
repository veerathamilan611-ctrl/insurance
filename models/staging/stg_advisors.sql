{{ config(materialized="view", schema="STAGE") }}

with
    source as (select * from {{ source("insurancemarket", "advisors") }}),

    renamed as (

        select
            nullif(trim(advisorid), '') as advisor_id,
            nullif(trim(advisorname), '') as advisor_name,
            initcap(nullif(trim(team), '')) as team,

            try_to_date(nullif(trim(joindate), '')) as join_date,

            try_to_number(nullif(trim(target_policies), '')) as target_policies,

            try_to_number(nullif(trim(target_revenue), '')) as target_revenue,

            _ingested_ts,
            _source_file_name

        from source

    )

select *
from renamed
