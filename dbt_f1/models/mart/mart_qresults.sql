with cqr as (
    select *
    from {{ ref('cleansed_qresults')}}
),

ro as (
    select *
    from {{ref('racesOrder2023')}}
)

select
    cqr.*,
    ro.round as race_order
from
    cqr
inner join
    ro
    on lower(cqr.track_country) = replace(ro.grand_prix_id, '-', ' ')
