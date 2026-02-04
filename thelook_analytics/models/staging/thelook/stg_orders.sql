{{
  config(
    materialized='view'
  )
}}

with source as (
  select * from {{ source('thelook_ecommerce', 'orders') }}
)

select
  cast(order_id as string) as order_id,
  cast(user_id as string) as user_id,
  cast(created_at as timestamp) as created_at,
  cast(shipped_at as timestamp) as shipped_at,
  cast(delivered_at as timestamp) as delivered_at,
  cast(returned_at as timestamp) as returned_at,
  cast(num_of_items as int64) as num_of_items,
  lower(status) as status
from source
