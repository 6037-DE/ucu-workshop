{{
  config(
    materialized='view'
  )
}}

with source as (
  select * from `bigquery-public-data.thelook_ecommerce.events`
)

select
  cast(id as string) as event_id,
  cast(user_id as string) as user_id,
  cast(session_id as string) as session_id,
  lower(event_type) as event_type,
  traffic_source,
  cast(created_at as timestamp) as created_at,
  date(cast(created_at as timestamp)) as event_date
from source
