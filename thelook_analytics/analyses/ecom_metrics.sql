WITH base AS (
  SELECT
    oi.order_id,
    oi.user_id,
    oi.sale_price,
    p.cost
  FROM thelook_copy.order_items oi
  JOIN thelook_copy.products p
    ON oi.product_id = p.id
  WHERE oi.status NOT IN ('Cancelled', 'Returned')
)

SELECT
  COUNT(DISTINCT order_id)                                   AS total_orders,
  COUNT(*)                                                   AS total_items_sold,
  COUNT(DISTINCT user_id)                                    AS total_customers,
  SUM(sale_price)                                            AS net_revenue,
  SUM(cost)                                                  AS cost_of_goods_sold,
  SUM(sale_price - cost)                                     AS gross_profit,
  SAFE_DIVIDE(SUM(sale_price), COUNT(DISTINCT order_id))     AS avg_order_value,
  SAFE_DIVIDE(SUM(sale_price), COUNT(*))                     AS avg_item_price,
  SAFE_DIVIDE(SUM(sale_price - cost), SUM(sale_price))       AS gross_margin,
  SAFE_DIVIDE(SUM(sale_price - cost), SUM(cost))             AS markup,
  SAFE_DIVIDE(SUM(sale_price), COUNT(DISTINCT user_id))      AS revenue_per_customer
FROM base;
