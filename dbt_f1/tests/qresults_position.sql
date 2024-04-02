select
    *
from
    {{ ref("cleansed_qresults")}}
where
    position < 1
    or position > 20
