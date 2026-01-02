--@ Fabric implemention of dbt_date.week_end().
--@ Source: dbt_date/macros/calendar_date/week_end.sql
--@param date (string): The date to calculate the week end of.
{% macro fabric__week_end(date) -%}
{%- set dt = dbt_date.week_start(date) -%}
{{ dbt_date.n_days_away(6, dt) }}
{%- endmacro %}
