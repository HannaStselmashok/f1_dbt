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
    -- for the driver who finished first - total time for the race
    -- for others - number of seconds they were behind the first driver
    -- for those who didn't start/finish - null
    case
        when finish_time_text like 'DN%'
        then null
        else
            case
                when finish_time_text like '+%'
                then finish_time_text
                else concat('0', finish_time_text)
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
        then concat('00:0', fastest_lap_time)
        else null
    end as fastest_lap_time
from
    F1.RAW_STAGING.RAW_RRESULTS
