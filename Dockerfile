FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1     PYTHONUNBUFFERED=1     DBT_PROFILES_DIR=/usr/app/profiles     DBT_PROJECT_DIR=/usr/app/project

WORKDIR /usr/app

RUN apt-get update && apt-get install -y --no-install-recommends       git       ca-certificates       tini     && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir       dbt-core==1.8.*       dbt-duckdb==1.8.*      

COPY . /usr/app/project
RUN mkdir -p /usr/app/profiles /usr/app/state

COPY docker/entrypoint.sh /usr/app/entrypoint.sh
RUN chmod +x /usr/app/entrypoint.sh

ENTRYPOINT ["/usr/bin/tini","--","/usr/app/entrypoint.sh"]
CMD ["dbt","--version"]


