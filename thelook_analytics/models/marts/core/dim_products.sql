{{ config(materialized='table') }}

select
  p.product_id,
  p.category,
  p.department,
  p.brand,
  p.retail_price,
  p.cost,
  case when p.retail_price is not null and p.retail_price <> 0
    then safe_cast((p.retail_price - p.cost) / p.retail_price as numeric)
    else null end as gross_margin,
  coalesce(oi.units_sold, 0) as units_sold,
  coalesce(oi.total_sales, 0) as total_sales
from {{ ref('stg_products') }} p
left join (
  select product_id, count(1) as units_sold, sum(sale_price) as total_sales
  from {{ ref('stg_order_items') }}
  group by product_id
) oi
  on p.product_id = oi.product_id
