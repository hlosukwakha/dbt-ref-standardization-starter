{% if var('use_demo_sources', true) %}
select
  trim(country_code) as country_code,
  trim(country_name) as country_name
from {{ ref('demo_erp_a_countries') }}
{% else %}
select
  trim(country_code) as country_code,
  trim(country_name) as country_name
from {{ source('erp_a', 'countries') }}
{% endif %}
