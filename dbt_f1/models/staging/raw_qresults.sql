with raw_qresults as (
    select
        *
    from
        F1.RAW.QRESULTS
)

select
    "Track" as track_country,
    "Position" as position,
    "No" as driver_number,
    "Driver" as driver_name,
    "Team" as team_name,
    "Q1" as first_qualifying_period,
    "Q2" as second_qualifying_period,
    "Q3" as third_qualifying_period,
    "Laps" as laps
from
    raw_qresults
