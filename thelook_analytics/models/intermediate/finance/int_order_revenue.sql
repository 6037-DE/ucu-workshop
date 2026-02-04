{{ config(materialized='table') }}

select
  oi.order_id,
  sum(oi.sale_price) as revenue,
  count(1) as items_count,
  safe_cast(avg(oi.sale_price) as numeric) as avg_price
from {{ ref('stg_order_items') }} oi
group by oi.order_id
