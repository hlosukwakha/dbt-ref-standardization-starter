select
  currency_code,
  currency_name,
  numeric,
  minor_unit,
  valid_from,
  valid_to,
  is_current
from {{ ref('iso_4217_currencies') }}
