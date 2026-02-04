{{
  config(
    materialized='table',
    partitions={'field': 'date', 'data_type': 'date'}
  )
}}

with sessions as (
  select session_id, session_date as date from {{ ref('int_event_sessions') }}
),
events as (
  select * from {{ ref('stg_events') }}
)

select
  s.date,
  count(distinct e.user_id) as active_users,
  count(distinct s.session_id) as sessions,
  sum(case when e.event_type = 'view' then 1 else 0 end) as product_views,
  sum(case when e.event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts,
  sum(case when e.event_type = 'purchase' then 1 else 0 end) as purchases,
  safe_divide(sum(case when e.event_type = 'purchase' then 1 else 0 end), nullif(sum(case when e.event_type = 'view' then 1 else 0 end),0)) as conversion_rate
from sessions s
left join events e on s.session_id = e.session_id
group by s.date
