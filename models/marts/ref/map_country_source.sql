with aliases as (
  select
    country_code,
    {{ normalize_country_name('alias') }} as alias_key
  from {{ ref('country_aliases') }}
),
erp_a as (
  select
    'ERP_A' as source_system,
    country_code as source_country_code,
    {{ normalize_country_name('country_name') }} as norm_name
  from {{ ref('stg_erp_a_country') }}
),
erp_b as (
  select
    'ERP_B' as source_system,
    country_alpha3 as source_country_code,
    {{ normalize_country_name('country_text') }} as norm_name
  from {{ ref('stg_erp_b_country') }}
),
all_src as (
  select * from erp_a
  union all
  select * from erp_b
),
match_by_name as (
  select
    s.source_system,
    s.source_country_code,
    c.country_code as canonical_country_code,
    current_timestamp as mapped_at,
    1 as match_rank
  from all_src s
  join {{ ref('iso_countries') }} c
    on s.norm_name = {{ normalize_country_name('c.country_name') }}
),
match_by_alias as (
  select
    s.source_system,
    s.source_country_code,
    a.country_code as canonical_country_code,
    current_timestamp as mapped_at,
    2 as match_rank
  from all_src s
  join aliases a
    on s.norm_name = a.alias_key
),
unified as (
  select * from match_by_name
  union all
  select * from match_by_alias
)
select
  source_system,
  source_country_code,
  canonical_country_code,
  mapped_at
from (
  select
    source_system,
    source_country_code,
    canonical_country_code,
    mapped_at,
    row_number() over (
      partition by source_system, source_country_code
      order by match_rank
    ) as rn
  from unified
) q
where rn = 1
