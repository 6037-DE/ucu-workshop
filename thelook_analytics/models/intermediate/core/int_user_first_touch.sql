{{ config(materialized='table') }}

with first_events as (
  select
    user_id,
    min(event_date) as first_event_date
  from {{ ref('stg_events') }}
  where user_id is not null
  group by user_id
)

select
  user_id,
  first_event_date,
  format_date('%Y-%m', first_event_date) as cohort_month
from first_events
