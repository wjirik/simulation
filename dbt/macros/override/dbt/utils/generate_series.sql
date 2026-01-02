--@ Overrides dbt.generate_series() to remove the ORDER BY clause, since it is not supported in TSQL for views and CTEs.
--@ Source: dbt/include/global_project/macros/utils/generate_series.sql
--@param upper_bound (integer): The number to generate a series up to. The series will include all integers from 1 to this number.
--@param result_as_cte (boolean): If true, the result will be wrapped in a CTE named `series` and is intended to be used as an input to another process (e.g., date_spine). If false, the result will be a standalone query.
{% macro fabric__generate_series(upper_bound, result_as_cte=true) %}
    {% set n = dbt.get_powers_of_two(upper_bound) %}
    with p as (
        select 0 as generated_number union all select 1
    )
    ,unioned as (
        select
            {% for i in range(n) %}
            p{{i}}.generated_number * power(2, {{i}})
            {% if not loop.last %} + {% endif %}
            {% endfor %}
            + 1 as generated_number
        from
        {% for i in range(n) %}
        p as p{{i}}
        {% if not loop.last %} cross join {% endif %}
        {% endfor %}
    )
    {% if result_as_cte %},series as ({% endif %}
    select *
    from unioned
    where generated_number <= {{upper_bound}}
    {#- In TSQL you can't have an order by in a view statement! -#}
    {#- order by generated_number #}
    {% if result_as_cte %}){% endif %}
{% endmacro %}