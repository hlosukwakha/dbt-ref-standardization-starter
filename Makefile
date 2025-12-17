.PHONY: build deps seed run test build_all docs bash clean

build:
	docker compose build

deps:
	docker compose run --rm dbt dbt deps

seed:
	docker compose run --rm dbt dbt seed

run:
	docker compose run --rm dbt dbt run

test:
	docker compose run --rm dbt dbt test

build_all:
	docker compose run --rm dbt dbt build

docs:
	docker compose run --rm dbt dbt docs generate

bash:
	docker compose run --rm dbt sh

clean:
	docker compose down -v
