{{
  config(
    materialized='table',
    partitions={'field': 'date', 'data_type': 'date'}
  )
}}

with orders as (
  select order_id, cast(created_at as date) as date from {{ ref('stg_orders') }}
),
rev as (
  select order_id, revenue from {{ ref('int_order_revenue') }}
),
costs as (
  select order_id, cost from {{ ref('int_order_cost') }}
)

select
  o.date,
  count(distinct o.order_id) as orders,
  sum(coalesce(r.revenue,0)) as net_revenue,
  sum(coalesce(c.cost,0)) as cogs,
  sum(coalesce(r.revenue,0) - coalesce(c.cost,0)) as gross_profit,
  sum(coalesce(r.items_count,0)) as items_sold,
  sum(coalesce(r.revenue,0)) / nullif(count(distinct o.order_id),0) as aov,
  case when sum(coalesce(r.revenue,0)) <> 0 then safe_cast(sum(coalesce(r.revenue,0) - coalesce(c.cost,0)) / sum(coalesce(r.revenue,0)) as numeric) else null end as margin_pct
from orders o
left join rev r on o.order_id = r.order_id
left join costs c on o.order_id = c.order_id
group by o.date
