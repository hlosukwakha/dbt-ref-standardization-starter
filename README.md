
Download: dbt-ref-standardization-starter.zip

What’s inside:
models/
* staging/ example staging for erp_a, erp_b, erp_c
* marts/ref/ → dim_country, dim_currency, map_country_source, map_currency_source
* sources.yml, ref.yml (tests & docs)
seeds/
* iso_countries.csv, un_m49_regions.csv, iso_4217_currencies.csv, country_aliases.csv
macros/normalize.sql (name folding helpers)
scripts/fetch_seeds.py (placeholder changelog bootstrap)
dbt_project.yml, packages.yml (with dbt_utils), profiles.example.yml, .gitignore, README.md
Usage:
unzip into your repo/workspace
set warehouse creds in profiles.yml (use profiles.example.yml as a guide)

run:
dbt deps
dbt seed
dbt run
dbt test 
