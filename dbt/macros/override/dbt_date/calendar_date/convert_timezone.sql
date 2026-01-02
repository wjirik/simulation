--@ Fabric implemention of dbt_date.convert_timezone().
--@ Source: dbt_date/macros/calendar_date/convert_timezone.sql
--@param column (string): The column to convert the timezone of.
--@param target_tz (string): The timezone to convert to.
--@param source_tz (string): The timezone to convert from.
{% macro fabric__convert_timezone(column, target_tz, source_tz) -%}
    cast(cast({{ column }} as {{ dbt.type_timestamp() }}) at time zone '{{ source_tz }}' at time zone '{{ target_tz }}' as datetime2(6))
{%- endmacro -%}