
{% macro fabric__get_delete_insert_merge_sql(target, source, unique_key, dest_columns, incremental_predicates=none) %}

    {% set query_label = apply_label() %}
    {%- set dest_cols_csv = get_quoted_csv(dest_columns | map(attribute="name")) -%}

    {% if unique_key %}
        {% if unique_key is sequence and unique_key is not string %}
            delete from {{ target }}
            where exists (
                select null
                from {{ source }}
                where
                {% for key in unique_key %}
                    ({{ source }}.{{ key }} = {{ target }}.{{ key }} or ({{ source }}.{{ key }} is NULL and  {{ target }}.{{ key }} is NULL))
                    {{ "and " if not loop.last }}
                {% endfor %}
            )
            {% if incremental_predicates %}
                {% for predicate in incremental_predicates %}
                    and {{ predicate }}
                {% endfor %}
            {% endif %}
            {{ query_label }}
        {% else %}
            delete from {{ target }}
            where (
                {{ unique_key }}) in (
                select ({{ unique_key }})
                from {{ source }}
            )
            {%- if incremental_predicates %}
                {% for predicate in incremental_predicates %}
                    and {{ predicate }}
                {% endfor %}
            {%- endif -%}
            {{ query_label }}
        {% endif %}
    {% endif %}

    insert into {{ target }} ({{ dest_cols_csv }})
    (
        select {{ dest_cols_csv }}
        from {{ source }}
    ){{ query_label }}
{% endmacro %}