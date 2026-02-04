{{ config(materialized='table') }}

with events as (
  select * from {{ ref('stg_events') }} where session_id is not null
),
session_bounds as (
  select
    session_id,
    any_value(user_id) as user_id,
    any_value(traffic_source) as traffic_source,
    min(created_at) as session_start,
    max(created_at) as session_end,
    min(event_date) as session_date,
    count(*) as events_count
  from events
  group by session_id
)

select
  session_id,
  user_id,
  traffic_source,
  session_start,
  session_end,
  session_date,
  events_count,
  timestamp_diff(session_end, session_start, second) as duration_seconds
from session_bounds
