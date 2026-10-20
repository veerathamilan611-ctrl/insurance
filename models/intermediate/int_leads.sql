{{ config(materialized="view", schema="INTERMEDIATE") }}

with
    source as (select * from {{ ref("stg_conversionfunnel") }}),

    deduplicated as (
        select *
        from source
        qualify
            row_number() over (
                partition by
                    quote_date,
                    product_type,
                    channel,
                    lead_source,
                    stage1_form_submitted,
                    stage1_date,
                    stage2_options_reviewed,
                    stage2_date,
                    advisor_consulted,
                    stage3_documents_uploaded,
                    stage3_date,
                    policy_purchased,
                    purchase_date,
                    drop_off_reason
                order by lead_id
            )
            = 1
    ),

    flags as (
        select
            *,

            -- DQ27: Set missing drop-off reasons to Unknown
            case
                when
                    policy_purchased = false
                    and (drop_off_reason is null or trim(drop_off_reason) = '')
                then 'Unknown'
                else drop_off_reason
            end as cleaned_drop_off_reason,

            -- Flag invalid stage progression
            case
                when stage2_options_reviewed = true and stage1_form_submitted = false
                then true
                when
                    stage3_documents_uploaded = true and stage2_options_reviewed = false
                then true
                when policy_purchased = true and stage3_documents_uploaded = false
                then true
                else false
            end as dq_stage_sequence_invalid,

            -- Flag invalid chronological order of stage dates
            case
                when stage2_date < stage1_date
                then true
                when stage3_date < stage2_date
                then true
                when purchase_date < stage3_date
                then true
                else false
            end as dq_stage_date_sequence_invalid,

            -- Check whether a lost lead has a recorded reason
            case
                when
                    policy_purchased = false
                    and drop_off_reason is not null
                    and trim(drop_off_reason) != ''
                then true
                else false
            end as has_drop_off_reason,

            -- Flag missing drop-off reason in the original data
            case
                when
                    policy_purchased = false
                    and (drop_off_reason is null or trim(drop_off_reason) = '')
                then true
                else false
            end as dq_missing_drop_off_reason,

            -- Estimate the stage where the lead dropped off
            case
                when policy_purchased = false and stage3_documents_uploaded = true
                then 'After Documents Uploaded'

                when policy_purchased = false and stage2_options_reviewed = true
                then 'After Options Reviewed'

                when policy_purchased = false and stage1_form_submitted = true
                then 'After Form Submitted'

                when policy_purchased = false
                then 'Before Form Submitted'

                else null
            end as derived_drop_off_stage

        from deduplicated
    )

select *
from flags
