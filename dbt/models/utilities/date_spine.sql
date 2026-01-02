{{ config(materialized='view') }}

--@ Created as a separate model, because in Fabric, CTEs cannot be nested within other CTEs.
-- date_day --@col Primary key --@tests unique
{{ dbt.date_spine(
    datepart="day",
    start_date="(select first_date from " + ref('date_limits') | string + ")",
    end_date="(select last_date from " + ref('date_limits') | string + ")"
) }}