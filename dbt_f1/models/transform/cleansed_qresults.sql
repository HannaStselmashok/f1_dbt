with raw_qresults as (
    select *
    from {{ ref("raw_qresults") }}
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
    case
        when regexp_like(first_qualifying_period, '^([0-9]+):([0-9]+)\.([0-9]+)$')
            and position('.', first_qualifying_period) > 0
        then concat('00:', first_qualifying_period)::time
        else null
    end as first_qualifying_period,
    case
        when regexp_like(second_qualifying_period, '^([0-9]+):([0-9]+)\.([0-9]+)$')
            and position('.', second_qualifying_period) > 0
        then concat('00:', second_qualifying_period)::time
        else null
    end as second_qualifying_period,
    case
        when regexp_like(third_qualifying_period, '^([0-9]+):([0-9]+)\.([0-9]+)$')
            and position('.', third_qualifying_period) > 0
        then concat('00:', third_qualifying_period)::time
        else null
    end as third_qualifying_period,
    laps
from
    F1.RAW_STAGING.RAW_QRESULTS
