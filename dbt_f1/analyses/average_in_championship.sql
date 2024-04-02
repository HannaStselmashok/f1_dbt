with rresults as (
        select
            *
        from
            {{ ref("mart_rresults")}}
),

drivers_ranked as (

    select
        team_name,
        driver_name,
        avg(position) as average_position,
        sum(points) as sum_points,
        row_number()
        over (
            partition by team_name
            order by sum(points) desc
            ) as row_number_drivers
    from
        rresults
    group by
        1, 2

), drivers_ranked_main as (

    select
        team_name,
        driver_name,
        round(average_position, 2) as average_position,
        sum_points,
        row_number_drivers
    from
        drivers_ranked
    where
        row_number_drivers <= 2
    order by
        1, 4 desc

)

select
    team_name,
    driver_name,
    average_position,
    sum_points,
    case
        when row_number_drivers = 1
        then round(sum_points / sum(sum_points)
            over (partition by team_name) * 100, 2)
        else null
    end as first_driver_ratio
from
    drivers_ranked_main
