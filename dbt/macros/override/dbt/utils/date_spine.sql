--@ Overrides dbt.date_spine() to work with Fabric and to add the end date to the date spine.
--@ Source: dbt/include/global_project/macros/utils/date_spine.sql
--@param datepart (string): The date part to generate the spine for (e.g., "day", "week", "month", "quarter", "year", etc.).
--@param start_date (string): The start date of the spine.
--@param end_date (string): The end date of the spine.
{% macro fabric__date_spine(datepart, start_date, end_date) %}
    {{ dbt.generate_series(dbt.get_intervals_between(start_date, end_date, datepart)) }}
    ,nums as (
        select row_number() over (order by (select null)) as n
        from series
    )
    ,all_periods as (
        select {{ start_date }} as date_{{ datepart }}
        union all

        {#- generate_series() combined with n means that all dates except the start date are included. n - 1 would ensure the start date is included, but not the end date. Just n ensures that the end date is included, but not the start date. #}
        select cast(({{ dbt.dateadd(datepart, "n", start_date) }}) as date) as date_{{ datepart }}
        from nums
    )
    select date_day
    from all_periods
{% endmacro %}