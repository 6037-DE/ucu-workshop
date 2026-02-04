{{ config(materialized='table') }}

with rev as (
  select * from {{ ref('int_order_revenue') }}
),
costs as (
  select * from {{ ref('int_order_cost') }}
)

select
  coalesce(r.order_id, c.order_id) as order_id,
  r.revenue,
  c.cost,
  r.items_count as items_sold,
  safe_cast(r.revenue - c.cost as numeric) as gross_profit,
  case when r.revenue is not null and r.revenue <> 0
    then safe_cast((r.revenue - c.cost) / r.revenue as numeric)
    else null end as margin_pct,
  case when c.cost is not null and c.cost <> 0
    then safe_cast((r.revenue - c.cost) / c.cost as numeric)
    else null end as markup
from rev r
full join costs c
  on r.order_id = c.order_id
