with base as (
  select
    country_code,
    country_name,
    alpha3,
    numeric,
    geonames_id,
    valid_from,
    valid_to,
    is_current
  from {{ ref('iso_countries') }}
),
regions as (
  select
    country_code,
    region_m49_code,
    subregion_m49_code
  from {{ ref('un_m49_regions') }}
)
select
  b.country_code,
  b.country_name,
  b.alpha3,
  b.numeric,
  r.region_m49_code,
  r.subregion_m49_code,
  b.geonames_id,
  b.valid_from,
  b.valid_to,
  b.is_current
from base b
left join regions r using (country_code)
