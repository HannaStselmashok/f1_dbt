with raw_rresults as (
    select
        *
    from
        F1.RAW.RRESULTS
)

select
    "Track" as track_country,
    "Position" as position,
    "No" as driver_number,
    "Driver" as driver_name,
    "Team" as team_name,
    "Starting_Grid" as starting_grid,
    "Laps" as laps,
    "Time_Retired" as finish_time_text,
    "Points" as points,
    "Set_Fastest_Lap" as has_set_fastest_lap,
    "Fastest_Lap_Time" as fastest_lap_time
from
    raw_rresults
