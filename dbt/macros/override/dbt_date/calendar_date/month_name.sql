--@ Fabric implemention of dbt_date.month_name().
--@ Source: dbt_date/macros/calendar_date/month_name.sql
--@param date (string): The date to extract the month name from.
--@param short (boolean): If true, it returns the short month name (e.g. "Jan"); otherwise, it returns the long month name (e.g. "January").
--@param language (string): Optional. The language to use for the day name. Required for v0.14.0+.
{% macro fabric__month_name(date, short, language='default') -%}
{%- set f = 'MMM' if short else 'MMMM' -%}
    format({{ date }}, '{{ f }}')
{%- endmacro %}