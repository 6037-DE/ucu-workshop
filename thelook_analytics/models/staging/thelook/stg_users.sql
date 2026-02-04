{{
  config(
    materialized='view'
  )
}}

with source as (
  select * from {{ source('thelook_ecommerce', 'users') }}
)

select
  cast(id as string) as user_id,
  cast(created_at as timestamp) as created_at,
  traffic_source,
  coalesce(nullif(country, ''), null) as country,
  coalesce(nullif(state, ''), null) as state,
  coalesce(nullif(city, ''), null) as city,
  cast(age as int64) as age,
  lower(gender) as gender
from source
