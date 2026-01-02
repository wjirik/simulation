--@ Returns a date or null if the date is less than the minimum date or an empty string
--@param date (string): The date or date column to be cleaned.
--@param min_date (string): Optional. The minimum date to be considered valid.
--@param data_type (string): Optional. The data type of the date column.
{% macro nullif_date(date, min_date='1970-01-01', data_type='date') -%}
case when cast(nullif(cast({{ date }} as varchar(255)), '') as {{ data_type }}) <= '{{ min_date }}' then null else cast(nullif(cast({{ date }} as varchar(255)), '') as {{ data_type }}) end
{%- endmacro %}