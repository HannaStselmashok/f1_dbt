with rresults as (
    select
        *
    from
        {{ ref("mart_rresults")}}
),


drivers_sum_points as (

    select
        race_order,
        track_country,
        team_name,
        driver_name,
        sum(points)
        over (
            partition by driver_name
            order by race_order
            ) as sum_points
    from
        rresults
    group by
        race_order,
        track_country,
        team_name,
        driver_name,
        points

), drivers_in_championship as (

    select
        race_order,
        track_country,
        team_name,
        driver_name,
        sum_points,
        dense_rank()
        over (
            partition by race_order
            order by sum_points desc
            ) as driver_in_championship
    from
        drivers_sum_points
    order by
        race_order,
        driver_name
)

select
    *
from
    drivers_in_championship
where
    team_name = 'Ferrari'
order by
    race_order,
    driver_name
