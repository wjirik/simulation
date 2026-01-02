--@ Fabric implemention of dbt_date.week_start(). Sunday as week start date.
--@ Source: dbt_date/macros/calendar_date/week_start.sql
--@param date (string): The date to calculate the week start of.
{% macro fabric__week_start(date) -%}
cast({{ dbt.dateadd('day', -1, dbt.date_trunc('week', date)) }} as date)
{%- endmacro %}
