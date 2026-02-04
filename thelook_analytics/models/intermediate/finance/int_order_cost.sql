{{ config(materialized='table') }}

select
  oi.order_id,
  sum(p.cost) as cost,
  count(1) as items_count,
  safe_cast(avg(p.cost) as numeric) as avg_cost_per_item
from {{ ref('stg_order_items') }} oi
left join {{ ref('stg_products') }} p
  on oi.product_id = p.product_id
group by oi.order_id
