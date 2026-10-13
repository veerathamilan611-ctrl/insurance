{{ config(materialized="view") }}

select
    a.advisor_key as advisor_sk,
    a.advisor_id,
    a.advisor_name,
    a.team as advisor_team,
    a.target_policies,
    a.target_revenue,

    count(f.policy_id) as policy_count,
    coalesce(sum(f.premium_amount), 0) as total_premium,

    count_if(f.policy_id is not null) as assigned_policy_count

from {{ ref("dim_advisor") }} a

left join {{ ref("fact_policy") }} f on a.advisor_key = f.advisor_sk

group by
    a.advisor_key,
    a.advisor_id,
    a.advisor_name,
    a.team,
    a.target_policies,
    a.target_revenue
