--@ Fabric implemention of dbt_date.day_name().
--@ Source: dbt_date/macros/calendar_date/day_name.sql
--@param date (string): The date to extract the day name from.
--@param short (boolean): If true, returns the short day name (e.g. "Mon"); otherwise, returns the full day name (e.g. "Monday").
--@param language (string): Optional. The language to use for the day name. Required for v0.14.0+.
{% macro fabric__day_name(date, short, language='default') -%}
{%- set f = 'ddd' if short else 'dddd' -%}
    format({{ date }}, '{{ f }}')
{%- endmacro %}