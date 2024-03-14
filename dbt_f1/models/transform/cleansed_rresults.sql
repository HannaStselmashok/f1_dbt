with RAW_RRESULTS as (
    select * from {{ ref ("raw_rresults")}}
)

select
    track_country,
    -- change positions NC and DQ to 20 (or any other letter values)
    case
        when regexp_like(position, '^[0-9]+$')
        then cast (position as integer)
        else 20
    end as position,
    driver_number,
    driver_name,
    team_name,
    starting_grid,
    laps,
    -- changed data types from varchar to time
    -- for the driver who finished first - total time for the race
    -- for others - number of seconds they were behind the first driver
    -- for those who didn't start/finish - null
    case
        when finish_time_text like '%:%'
        then finish_time_text ::time
        else
            case
                when finish_time_text like '%lap%'
                    or finish_time_text like 'DN%'
                then null
                    else
                        case
                            when cast(substring(finish_time_text, 2) as float) > 59
                            then dateadd(second, cast(substring(finish_time_text, 2) as float) + 1, to_timestamp('1970-01-01 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3')) ::time
                            else dateadd(second, cast(substring(finish_time_text, 2) as float), to_timestamp('1970-01-01 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3')) ::time
                        end
            end
    end as finish_time,
    points,
    -- changed "Yes" and "No" to 1 and 0 accord.
    case
        when has_set_fastest_lap = 'Yes'
        then 1
        else 0
    end as has_set_fastest_lap,
    -- changed type from varchar to time
    case
        when regexp_like(fastest_lap_time, '^([0-9]+):([0-9]+)\.([0-9]+)$')
        -- then to_char(to_timestamp(fastest_lap_time, 'MI:SS.FF'), 'HH24:MI:SS.FF3')
        then concat('00:', fastest_lap_time)::time
        else null
    end as fastest_lap_time
from
    F1.RAW_STAGING.RAW_RRESULTS
