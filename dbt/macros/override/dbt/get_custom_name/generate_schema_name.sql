--@ Overrides dbt.generate_schema_name() to remove the target schema as a prefix from the schema name.
--@ Source: dbt/include/global_project/macros/get_custom_name/get_custom_schema.sql
--@param custom_schema_name (string): The configured value of schema in the specified node, or the default schema if a value is not supplied.
--@param node (object): The node that is currently being processed by dbt.
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}