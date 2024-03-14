with crr as (
    select *
    from {{ ref('cleansed_rresults')}}
),

ro as (
    select *
    from {{ref('racesOrder2023')}}
)

select
    crr.*,
    ro.round as race_order
from
    crr
inner join
    ro
    on lower(crr.track_country) = replace(ro.grand_prix_id, '-', ' ')
