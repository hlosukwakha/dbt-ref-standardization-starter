select
  trim(currency_code) as currency_code,
  trim(currency_name) as currency_name
from {{ ref('demo_erp_c_currencies') }}
