{% macro fold_ascii(text) -%}
    -- Warehouse-agnostic normalization: lowercase + strip non-alphanumerics.
    -- If your warehouse supports UNACCENT, you can wrap that here.
    lower(regexp_replace({{ text }}, '[^a-zA-Z0-9]+', ''))
{%- endmacro %}

{% macro normalize_country_name(col) -%}
    {{ fold_ascii(col) }}
{%- endmacro %}
