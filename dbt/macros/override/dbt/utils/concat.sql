--@ Overrides dbt.fabric__concat() to check if there are at least two fields to concatenate before using the SQL concat(). In Fabric, concat() requires a minimum of two arguments.
--@ Source: dbt/include/fabric/macros/utils/concat.sql
--@param fields (list): A list of fields to concatenate.
{% macro fabric__concat(fields) -%}
    {%- if fields|length > 1 -%}
        concat({{ fields|join(', ') }})
    {%- else -%}
        {{ fields[0] }}
    {%- endif -%}
{%- endmacro %}