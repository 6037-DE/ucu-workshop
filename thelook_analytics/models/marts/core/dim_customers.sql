{{ config(materialized='table') }}

select
  u.user_id,
  u.created_at as user_created_at,
  u.traffic_source,
  u.country,
  u.state,
  u.city,
  u.age,
  u.gender,
  f.first_event_date,
  f.cohort_month,
  coalesce(o.orders_count, 0) as orders_count,
  coalesce(o.items_count, 0) as items_count,
  coalesce(r.lifetime_revenue, 0) as lifetime_revenue,
  case when coalesce(o.orders_count,0) > 0
    then safe_cast(coalesce(r.lifetime_revenue,0) / o.orders_count as numeric)
    else null end as avg_order_value,
  r.last_order_date
from {{ ref('stg_users') }} u
left join {{ ref('int_user_first_touch') }} f
  on u.user_id = f.user_id
left join (
  select user_id, count(distinct order_id) as orders_count, sum(num_of_items) as items_count
  from {{ ref('stg_orders') }}
  group by user_id
) o
  on u.user_id = o.user_id
left join (
  select
    o.user_id,
    sum(coalesce(r.revenue,0)) as lifetime_revenue,
    max(cast(o.created_at as date)) as last_order_date
  from {{ ref('stg_orders') }} o
  left join {{ ref('int_order_revenue') }} r on o.order_id = r.order_id
  group by o.user_id
) r
  on u.user_id = r.user_id
