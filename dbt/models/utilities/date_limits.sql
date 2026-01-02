{%- set max_future_years = 2 -%}
{%- set max_past_years = 2 -%}
{%- set query -%}
    select
        table_schema
        ,table_name
        ,column_name
    from {{ target.database }}.INFORMATION_SCHEMA.COLUMNS -- must be uppercase
    where table_schema like '{{ generate_schema_name("dw") }}'
        and column_name like '%date%'
        and table_name like 'fact%';
{%- endset -%}

{%- if execute -%}
    {%- set date_columns = run_query(query) -%}
{%- else -%}
    {%- set date_columns = [] -%}
{%- endif -%}

--@ Contains the min/max dates for all date columns from all fact tables
with table_dates as (
    select
        'DEFAULT' as column_name
        ,'DEFAULT' as table_name
        ,dateadd(year, -{{ max_past_years }}, {{ dbt_date.today() }}) as min_date
        ,dateadd(year, {{ max_future_years }}, {{ dbt_date.today() }}) as max_date
{% for date_column in date_columns %}
    {# column name referencing for the date_column object is case-sensitive #}
    union all

    select
        '{{date_column.column_name }}' as column_name
        ,'{{ date_column.table_name }}' as table_name
        ,min(cast({{date_column.column_name }} as date)) as min_date
        ,max(cast({{date_column.column_name }} as date)) as max_date
    from {{ target.database }}.{{ date_column.table_schema }}.{{ date_column.table_name }}
{%- endfor %}
)
select
    datetrunc(month, min(min_date)) as first_date,
    eomonth(least(max(max_date), dateadd(year, {{ max_future_years }}, {{ dbt_date.today() }}))) as last_date
from table_dates