--@ Fabric implemention of dbt_date.date_part().
--@ Source: dbt_date/macros/calendar_date/date_part.sql
--@param datepart (string): The date part to extract from the date (e.g., "year", "quarter", "month", etc.).
--@param date (string): The date from which to extract the date part.
{% macro fabric__date_part(datepart, date) -%}
    datepart({{ datepart }}, {{ date }})
{%- endmacro %}