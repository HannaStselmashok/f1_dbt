select
    *
from
    {{ ref("cleansed_rresults")}}
where
    position < 1
    or position > 20
