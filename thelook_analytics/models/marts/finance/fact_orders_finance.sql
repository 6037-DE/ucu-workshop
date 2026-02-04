{{ config(materialized='table') }}

select
  o.order_id,
  cast(o.created_at as date) as order_date,
  o.user_id,
  coalesce(r.revenue, 0) as revenue,
  coalesce(c.cost, 0) as cost,
  coalesce(r.items_count, 0) as items_count,
  coalesce(r.revenue,0) - coalesce(c.cost,0) as gross_profit,
  case when coalesce(r.revenue,0) <> 0 then safe_cast((coalesce(r.revenue,0) - coalesce(c.cost,0)) / coalesce(r.revenue,0) as numeric) else null end as margin_pct,
  o.status
from {{ ref('stg_orders') }} o
left join {{ ref('int_order_revenue') }} r
  on o.order_id = r.order_id
left join {{ ref('int_order_cost') }} c
  on o.order_id = c.order_id
