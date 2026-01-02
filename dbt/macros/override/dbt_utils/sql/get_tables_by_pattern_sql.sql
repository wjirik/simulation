--@ Fabric implemention of dbt_utils.get_tables_by_pattern_sql().
--@ Source: dbt_utils/macros/sql/get_tables_by_pattern_sql.sql
--@param schema_pattern (string): The schema pattern to inspect for relations (case insensitive).
--@param table_pattern (string): The name pattern of the table/view (case insensitive).
--@param exclude (string): Optional. Exclude any relations that match this table pattern (case insensitive).
--@param database (string): Optional. The database to inspect for relations.
{% macro fabric__get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}
    select distinct
        table_schema as {{ adapter.quote('table_schema') }},
        table_name as {{ adapter.quote('table_name') }},
        {{ dbt_utils.get_table_types_sql() }}
    from {{ database }}.INFORMATION_SCHEMA.TABLES
    where table_schema like '{{ schema_pattern }}'
        and table_name like '{{ table_pattern }}'
        and table_name not like '{{ exclude }}'
{% endmacro %}