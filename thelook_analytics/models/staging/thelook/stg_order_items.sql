{{
  config(
    materialized='view'
  )
}}

with source as (
select * from {{ source('thelook_ecommerce', 'order_items') }}
)

select
  cast(id as string) as order_item_id,
  cast(order_id as string) as order_id,
  cast(product_id as string) as product_id,
  cast(sale_price as numeric) as sale_price,
  lower(status) as status
from source
