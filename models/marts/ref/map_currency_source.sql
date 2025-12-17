with erp_c as (
  select
    'ERP_C' as source_system,
    currency_code as source_currency_code,
    {{ fold_ascii('currency_name') }} as norm_name
  from {{ ref('stg_erp_c_currency') }}
),
match as (
  select
    e.source_system,
    e.source_currency_code,
    d.currency_code as canonical_currency_code,
    current_timestamp as mapped_at
  from erp_c e
  join {{ ref('dim_currency') }} d
    on upper(e.source_currency_code) = d.currency_code
)
select * from match
