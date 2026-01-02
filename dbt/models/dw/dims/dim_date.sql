--@ Grain: One row per day
--@ Includes columns to indicate holidays, YOY, month name, month number, day of the week, etc.
--@ Intentionally not using the insert_unknown_member() macro in this dimension, because dates in fact tables aren't going to default to a specific date.
with step_1 as (
    select 
        d.date_day as date
        ,{{ dbt_date.today() }} as today
        ,{{ dbt_date.day_of_week('d.date_day', isoweek=false) }} as day_of_week
        ,cast({{ dbt_date.day_name('d.date_day') }} as varchar(3)) as day_of_week_name_short
        ,{{ dbt_date.date_part('year', 'd.date_day') }} as year_num
        ,{{ dbt_date.date_part('month', 'd.date_day') }} as month_num
        ,cast({{ dbt_date.month_name('d.date_day') }} as varchar(3)) as month_name
        ,cast({{ dbt_date.month_name('d.date_day', short=false) }} as varchar(9)) as month_name_long
        ,{{ dbt_date.date_part('quarter', 'd.date_day') }} as quarter_num
        ,{{ dbt_date.day_of_month('d.date_day') }} as day_of_month
        ,{{ dbt_date.date_part('dayofyear', 'd.date_day') }} as day_of_year
        ,{{ dbt_date.week_start('d.date_day') }} as week_start_date
        ,{{ dbt_date.week_end('d.date_day') }} as week_end_date
        ,{{ dbt.date_trunc('month', 'd.date_day') }} as month_start_date
        ,{{ dbt.last_day('d.date_day', 'month') }} as month_end_date
        ,{{ dbt.date_trunc('year', 'd.date_day') }} as year_start_date
        ,{{ dbt.last_day('d.date_day', 'year') }} as year_end_date
        ,{{ dbt_date.date_part('month', dbt_date.today()) }} as current_month_num
        ,{{ dbt_date.date_part('year', dbt_date.today()) }} as current_year_num
    from {{ ref('date_spine') }} d
)
,step_2 as (
    select
        s.date
        ,s.day_of_week
        ,s.day_of_week_name_short
        ,s.year_num
        ,s.month_num
        ,s.month_name
        ,s.month_name_long
        ,s.quarter_num 
        ,cast('Q' + cast(s.quarter_num as char(1)) as varchar(2)) as quarter_name
        ,s.day_of_month
        ,s.day_of_year
        ,s.week_start_date
        ,s.week_end_date
        ,cast(cast(s.week_start_date as varchar(10)) + ' - ' + cast(s.week_end_date as varchar(10)) as varchar(23)) as week_range
        ,s.month_start_date
        ,s.month_end_date
        ,s.year_start_date
        ,s.year_end_date
        ,cast(case when s.day_of_week_name_short in ('Sat', 'Sun') then 1 else 0 end as bit) as is_weekend
        ,cast(case
            when s.year_num = s.current_year_num
                and s.date <= s.today then 'YTD'
            else 'Not YTD'
        end as varchar(7)) as ytd
        ,cast(case
            when s.year_num = s.current_year_num
                and s.month_num = s.current_month_num
                and s.date <= s.today then 'MTD'
            else 'Not MTD'
        end as varchar(7)) as mtd
        ,case
            when s.date <= {{ dbt_date.n_days_ago(31) }} then 'Last 31+ Days'
            when s.date between {{ dbt_date.n_days_ago(30) }} and {{ dbt_date.n_days_ago(15) }} then 'Last 15 - 30 Days'
            when s.date between {{ dbt_date.n_days_ago(14) }} and {{ dbt_date.n_days_ago(8) }} then 'Last 8 - 14 Days'
            when s.date between {{ dbt_date.n_days_ago(7) }} and {{ dbt_date.n_days_ago(2) }} then 'Last 2 - 7 Days'
            when s.date = {{ dbt_date.yesterday() }} then 'Yesterday'
            when s.date = s.today then 'Today'
            when s.date = {{ dbt_date.tomorrow() }} then 'Tomorrow'
            when s.date between {{ dbt_date.n_days_away(2) }} and {{ dbt_date.n_days_away(7) }} then 'Next 2 - 7 Days'
            when s.date between {{ dbt_date.n_days_away(8) }} and {{ dbt_date.n_days_away(14) }} then 'Next 8 - 14 Days'
            when s.date between {{ dbt_date.n_days_away(15) }} and {{ dbt_date.n_days_away(30) }} then 'Next 15 - 30 Days'
            when s.date >= {{ dbt_date.n_days_away(31) }} then 'Next 31+ Days'
            else 'Error'
        end as date_buckets
        ,case
            when s.date <= {{ dbt_date.n_days_ago(31) }} then 1
            when s.date between {{ dbt_date.n_days_ago(30) }} and {{ dbt_date.n_days_ago(15) }} then 2
            when s.date between {{ dbt_date.n_days_ago(14) }} and {{ dbt_date.n_days_ago(8) }} then 3
            when s.date between {{ dbt_date.n_days_ago(7) }} and {{ dbt_date.n_days_ago(2) }} then 4
            when s.date = {{ dbt_date.yesterday() }} then 5
            when s.date = s.today then 6
            when s.date = {{ dbt_date.tomorrow() }} then 7
            when s.date between {{ dbt_date.n_days_away(2) }} and {{ dbt_date.n_days_away(7) }} then 8
            when s.date between {{ dbt_date.n_days_away(8) }} and {{ dbt_date.n_days_away(14) }} then 9
            when s.date between {{ dbt_date.n_days_away(15) }} and {{ dbt_date.n_days_away(30) }} then 10
            when s.date >= {{ dbt_date.n_days_away(31) }} then 11
            else 12
        end as date_buckets_sort_column
        ,cast(case
            when s.date >= s.today then 'Future'
            else 'Past'
        end as varchar(11)) as future_or_past
    from step_1 s
)
,step_3 as (
    select
        s.date
        ,s.day_of_week
        ,s.day_of_week_name_short
        ,s.year_num
        ,s.month_num
        ,s.month_name
        ,s.month_name_long
        ,cast(s.year_num as varchar(4)) + '-' + right('0' + cast(s.month_num as varchar(2)), 2) as year_month
        ,s.month_name + ' ' + cast(s.year_num as varchar(4)) as year_month_name
        ,s.quarter_num
        ,s.quarter_name
        ,cast(s.year_num as varchar(4)) + '-' + s.quarter_name as year_quarter
        ,s.day_of_month
        ,s.day_of_year
        ,s.week_start_date
        ,s.week_end_date
        ,s.week_range
        ,s.month_start_date
        ,s.month_end_date
        ,s.year_start_date
        ,s.year_end_date
        ,s.is_weekend
        ,s.ytd
        ,s.mtd
        ,s.date_buckets
        ,s.date_buckets_sort_column
        ,s.future_or_past
    from step_2 s
)
select
    s.date --@col Date column and primary key --@tests unique
    ,s.day_of_week --@col Numerical value for weekday. 1 (Sunday) to 7 (Saturday)
    ,s.day_of_week_name_short --@col Short 3-letter weekday name
    ,s.year_num --@col 4-digit year number
    ,s.month_num --@col Month Number (no leading 0)
    ,s.month_name --@col Short 3 letter month name
    ,s.month_name_long --@col Long 9 letter month name
    ,s.year_month --@col Year and month (e.g., '2024-07')
    ,s.year_month_name --@col year and month name (e.g., 'October 2024')
    ,s.quarter_num --@col Quarter number value based off calendar year
    ,s.quarter_name --@col Quarter name (Q1, Q2, Q3, Q4) based off calendar year
    ,s.year_quarter --@col Year and quarter (e.g., '2024-Q3')
    ,s.day_of_month --@col Numerical value for the day of the month. For example, 28
    ,s.day_of_year --@col A number ranging from 1-365 representing the day of the year
    ,s.week_start_date --@col Date that the week started (Sunday)
    ,s.week_end_date --@col Date that the week ended (Saturday)
    ,s.week_range --@col String of the week start and end dates (e.g., '2022-10-23 - 2022-10-29')
    ,s.month_start_date --@col Date that the month started
    ,s.month_end_date --@col Date that the Month Ended
    ,s.year_start_date --@col January 1st of the year
    ,s.year_end_date --@col December 31st of the year
    ,s.is_weekend --@col True if the date is Sat or Sun
    ,s.ytd --@col Is the date between the first day of the year and today?
    ,s.mtd --@col Is the date between the first day of the current month and today?
    ,s.date_buckets --@col Buckets representing date ranges such as Today, Tomorrow, Next 2-7 days or last 2-7 days.
    ,s.date_buckets_sort_column --@col Number column to tell visual tools how to sort the date buckets column
    ,s.future_or_past --@col represents if the date is historical or future
from step_3 s