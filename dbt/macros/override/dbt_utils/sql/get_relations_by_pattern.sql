--@ Returns a list of Relation objects that match a given schema- or table-name pattern in Snowflake. Largely based on dbt_utils.get_relations_by_pattern(), but it's been modified to be able to exclude relations by a schema pattern in addition to a table pattern.
--@ Source: dbt_utils/macros/sql/get_relations_by_pattern.sql
--@param schema_pattern (string): The schema pattern to inspect for relations (case insensitive).
--@param table_pattern (string): The name pattern of the table/view (case insensitive).
--@param exclude_table_pattern (string): Optional. Exclude any relations that match this table pattern (case insensitive).
--@param exclude_schema_pattern (string): Optional. Exclude any relations that match this schema pattern (case insensitive).
--@param database (string): Optional. The database to inspect for relations.
{% macro get_relations_by_pattern(schema_pattern, table_pattern, exclude_table_pattern='', exclude_schema_pattern='%_incremental', database=target.database) %}
    {%- set sql -%}
        select distinct
            TABLE_SCHEMA,
            TABLE_NAME,
            {{- dbt_utils.get_table_types_sql() }}
        from {{ database }}.INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA like upper('{{ schema_pattern }}')
            and TABLE_NAME like upper('{{ table_pattern }}')
            and TABLE_NAME not like upper('{{ exclude_table_pattern }}')
            and TABLE_SCHEMA not like upper('{{ exclude_schema_pattern }}')
    {%- endset -%}

    {%- set tables = get_query_results_as_list(sql) -%}
    {%- set tbl_relations = [] -%}

    {%- if tables -%}
        {%- for table in tables -%}
            {# key 'table_type' must be lowercase, because that's what dbt_utils.get_table_types_sql() returns #}
            {%- set tbl_relation = api.Relation.create(
                database=database,
                schema=table['TABLE_SCHEMA'],
                identifier=table['TABLE_NAME'],
                type=table['table_type']
            ) -%}
            {%- do tbl_relations.append(tbl_relation) -%}
        {%- endfor -%}
    {%- endif -%}

    {{ return(tbl_relations) }}
{% endmacro %}