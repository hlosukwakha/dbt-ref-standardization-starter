select
  trim(country_alpha3) as country_alpha3,
  trim(country_text)  as country_text
from {{ ref('demo_erp_b_countries') }}
