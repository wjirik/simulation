--@ Fabric implemention of dbt_date.day_of_week().
--@ Source: dbt_date/macros/calendar_date/day_of_week.sql
--@param date (string): The date to extract the day of the week from.
--@param isoweek (boolean): If true, return the day of the week in ISO format (1 = Monday, 7 = Sunday); otherwise, return the day of the week as (1 = Sunday, 7 = Saturday).
{% macro fabric__day_of_week(date, isoweek) -%}
    {%- set dow = dbt_date.date_part('weekday', date) -%}

    {%- if isoweek -%}
    case
        -- Shift start of week from Sunday (1) to Monday (2)
        when {{ dow }} = 1 then 7
        else {{ dow }} - 1
    end
    {%- else -%}
    {{ dow }}
    {%- endif -%}
{%- endmacro %}