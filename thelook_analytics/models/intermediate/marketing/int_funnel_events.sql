{{ config(materialized='table') }}

with session_events as (
  select
    s.session_id,
    s.session_date,
    any_value(s.user_id) as user_id,
    any_value(s.traffic_source) as traffic_source,
    max(case when e.event_type = 'view' then 1 else 0 end) as has_view,
    max(case when e.event_type = 'add_to_cart' then 1 else 0 end) as has_cart,
    max(case when e.event_type = 'purchase' then 1 else 0 end) as has_purchase,
    (max(case when e.event_type = 'view' then 1 else 0 end) +
     max(case when e.event_type = 'add_to_cart' then 1 else 0 end) +
     max(case when e.event_type = 'purchase' then 1 else 0 end)) as funnel_steps
  from {{ ref('stg_events') }} e
  join {{ ref('int_event_sessions') }} s
    on e.session_id = s.session_id
  group by s.session_id, s.session_date
)

select * from session_events
