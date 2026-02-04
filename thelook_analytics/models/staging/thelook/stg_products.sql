{{
  config(
    materialized='view'
  )
}}

with source as (
  select * from {{ source('thelook_ecommerce', 'products') }}
)

select
  cast(id as string) as product_id,
  category,
  department,
  brand,
  cast(retail_price as numeric) as retail_price,
  cast(cost as numeric) as cost
from source
