{{ config(materialized="view", schema="STAGE") }}

with
    source as (select * from {{ source("insurancemarket", "conversionfunnel") }}),

    renamed as (

        select
            nullif(trim(leadid), '') as lead_id,

            try_to_date(nullif(trim(quotedate), '')) as quote_date,

            initcap(nullif(trim(producttype), '')) as product_type,
            upper(nullif(trim(channel), '')) as channel,
            upper(nullif(trim(leadsource), '')) as lead_source,

            try_to_boolean(
                nullif(trim(stage1_formsubmitted), '')
            ) as stage1_form_submitted,

            try_to_date(nullif(trim(stage1_date), '')) as stage1_date,

            try_to_boolean(
                nullif(trim(stage2_optionsreviewed), '')
            ) as stage2_options_reviewed,

            try_to_date(nullif(trim(stage2_date), '')) as stage2_date,

            try_to_boolean(nullif(trim(advisorconsulted), '')) as advisor_consulted,

            try_to_boolean(
                nullif(trim(stage3_documentsuploaded), '')
            ) as stage3_documents_uploaded,

            try_to_date(nullif(trim(stage3_date), '')) as stage3_date,

            try_to_boolean(nullif(trim(policypurchased), '')) as policy_purchased,

            try_to_date(nullif(trim(purchasedate), '')) as purchase_date,

            nullif(trim(dropoffreason), '') as drop_off_reason,

            _ingested_ts,
            _source_file_name

        from source

    )

select *
from renamed
