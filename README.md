# Master / Reference Data Standardization with dbt (Dockerized)

![dbt](https://img.shields.io/badge/dbt-1.8.x-orange)
![Docker](https://img.shields.io/badge/Docker-ready-blue)
![DuckDB](https://img.shields.io/badge/DuckDB-local%20default-green)
![SQL](https://img.shields.io/badge/SQL-ANSI-lightgrey)
![YAML](https://img.shields.io/badge/YAML-config-informational)
![Python](https://img.shields.io/badge/Python-3.12-blue)
![License](https://img.shields.io/badge/License-MIT-success)

---

## Overview (Blog‑style)

Master and Reference Data (countries, currencies, codes, classifications) are deceptively simple — yet they are one of the **largest sources of inconsistency, reconciliation work, and reporting errors** across organisations.

This project provides a **practical, production‑ready reference data standardisation pattern** using:

- **dbt** for transformations, testing, and documentation  
- **Authoritative open standards** (ISO 3166, ISO 4217, UN M49)  
- **Docker** for fully reproducible execution  
- **DuckDB** as a zero‑dependency local warehouse (swap‑in Snowflake, BigQuery, etc.)

The result is a clean, canonical set of dimensions (`dim_country`, `dim_currency`) and explicit **mapping tables** that translate messy ERP/source system values into standardised codes.

This pattern is directly applicable to:
- Data platforms & analytics teams  
- MDM / Data Governance initiatives  
- ERP consolidation programs  
- Cloud migrations  
- Regulatory and financial reporting  

---

## Project Tree

```text
dbt-ref-standardization-starter/
├── Dockerfile
├── docker-compose.yml
├── Makefile
├── dbt_project.yml
├── packages.yml
├── README.md
├── profiles/
│   └── profiles.yml
├── docker/
│   └── entrypoint.sh
├── seeds/
│   ├── iso_countries.csv
│   ├── iso_4217_currencies.csv
│   ├── un_m49_regions.csv
│   ├── country_aliases.csv
│   ├── demo_erp_a_countries.csv
│   ├── demo_erp_b_countries.csv
│   └── demo_erp_c_currencies.csv
├── macros/
│   └── normalize.sql
├── models/
│   ├── sources.yml
│   ├── staging/
│   │   ├── stg_erp_a_country.sql
│   │   ├── stg_erp_b_country.sql
│   │   └── stg_erp_c_currency.sql
│   ├── marts/
│   │   └── ref/
│   │       ├── dim_country.sql
│   │       ├── dim_currency.sql
│   │       ├── map_country_source.sql
│   │       └── map_currency_source.sql
│   └── ref.yml
└── scripts/
    └── fetch_seeds.py
```

---

## Technology Stack Explained

| Component | Purpose |
|---------|--------|
| **dbt Core** | SQL‑first transformation, testing, lineage, and documentation |
| **DuckDB** | Lightweight analytical database for local/demo runs |
| **Docker / Compose** | Reproducible execution environment |
| **dbt-utils** | Standard macros and tests (installed via `dbt deps`) |
| **SQL** | Transformations and modelling |
| **YAML** | Configuration, tests, metadata |
| **Python** | Helper scripts (seed refresh, automation) |

---

## How the Project Works

### Seeds (Authoritative & Demo Data)
- `iso_countries.csv` – ISO‑3166 country codes  
- `iso_4217_currencies.csv` – ISO currency codes  
- `un_m49_regions.csv` – UN regions/sub‑regions  
- `country_aliases.csv` – synonyms and local variants  
- `demo_erp_*` – simulated ERP inputs so the project runs out‑of‑the‑box  

Seeds are loaded into the warehouse and act as **controlled reference tables**.

---

### Staging Models
Located under `models/staging/`.

They represent **raw system views**:
- Rename fields
- Trim values
- Prepare for mapping

In demo mode, they read from seeded demo tables.  
In production, they can be switched to `source()` tables.

---

### Reference (Mart) Models
Located under `models/marts/ref/`.

| Model | Purpose |
|-----|--------|
| `dim_country` | Canonical country dimension |
| `dim_currency` | Canonical currency dimension |
| `map_country_source` | ERP → ISO country mapping |
| `map_currency_source` | ERP → ISO currency mapping |

These are the **tables downstream analytics and integrations should use**.

---

### Macros
- `normalize.sql` – canonicalises text (case‑folding, stripping symbols)  
Used to reliably match inconsistent source values.

---

### Tests & Documentation
Defined in `models/ref.yml`:
- Uniqueness
- Not‑null constraints
- Referential integrity

Run with:
```bash
dbt test
```


---

## Running the Project (Docker)

### Build the image
```bash
docker compose build
```

### Run everything (seeds + models + tests)
```bash
docker compose run --rm dbt dbt build
```

Or using Make:
```bash
make build
make build_all
```

---

## Testing & Validation

```bash
docker compose run --rm dbt dbt test
```

```
21:32:07  1 of 6 START test dbt_utils_unique_combination_of_columns_dim_country_country_code  [RUN]
21:32:07  2 of 6 START test not_null_dim_country_country_code ............................ [RUN]
21:32:07  3 of 6 START test not_null_dim_currency_minor_unit ............................. [RUN]
21:32:07  4 of 6 START test relationships_map_country_source_canonical_country_code__country_code__ref_dim_country_  [RUN]
21:32:07  3 of 6 PASS not_null_dim_currency_minor_unit ................................... [PASS in 0.07s]
21:32:07  2 of 6 PASS not_null_dim_country_country_code .................................. [PASS in 0.07s]
21:32:07  4 of 6 PASS relationships_map_country_source_canonical_country_code__country_code__ref_dim_country_  [PASS in 0.07s]
21:32:07  5 of 6 START test relationships_map_currency_source_canonical_currency_code__currency_code__ref_dim_currency_  [RUN]
21:32:07  1 of 6 PASS dbt_utils_unique_combination_of_columns_dim_country_country_code ... [PASS in 0.08s]
21:32:07  6 of 6 START test unique_dim_currency_currency_code ............................ [RUN]
21:32:07  6 of 6 PASS unique_dim_currency_currency_code .................................. [PASS in 0.02s]
21:32:07  5 of 6 PASS relationships_map_currency_source_canonical_currency_code__currency_code__ref_dim_currency_  [PASS in 0.03s]
```

Failures usually indicate:
- Missing mappings
- Invalid reference data
- Unexpected source values

---

## Configuration Files Explained

| File | Purpose |
|----|-------|
| `Dockerfile` | dbt runtime image |
| `docker-compose.yml` | Orchestration & volumes |
| `profiles.yml` | Warehouse connection |
| `dbt_project.yml` | Project settings |
| `packages.yml` | dbt dependencies |
| `sources.yml` | External system contracts |
| `ref.yml` | Tests & model docs |

---

## Common Errors & Troubleshooting

### ❌ `Table does not exist`
**Cause:** staging model points to non‑existent `source()`  
**Fix:** use demo seeds or configure real source schemas

---

### ❌ `dbt-utils not found`
**Cause:** installed via pip  
**Fix:** remove from pip, use `packages.yml` + `dbt deps`

---

### ❌ `not a valid semantic version`
**Cause:** invalid version syntax in `packages.yml`  
**Fix:** pin version or use list syntax

---

## Extending the Project

You can easily add:
- ISO‑3166‑2 subdivisions
- Time zones
- Product classifications (UNSPSC)
- Bank codes (BIC, routing numbers)
- SCD‑2 historisation
- API‑driven validation

The pattern remains the same:
**Authoritative seed → staging → canonical dimension → mappings**

---

## Scripts

`scripts/fetch_seeds.py`  
Placeholder for:
- Automated seed refresh
- Change logs
- Governance workflows

---

## Who Should Use This

- Data Architects
- MDM Specialists
- Analytics Engineers
- Platform / Cloud Engineers
- Governance & Compliance teams

---

## Signature

Built with care by  
**@hlosukwakha**  
Data Governance • Cloud Data Platforms • Analytics • Data Architecture