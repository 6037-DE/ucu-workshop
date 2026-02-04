-- Do all users generate events?
SELECT
  COUNT(DISTINCT u.id) AS users,
  COUNT(DISTINCT e.user_id) AS users_with_events
FROM thelook_copy.users u
LEFT JOIN thelook_copy.events e
  ON u.id = e.user_id;

-- Do orders contain multiple items?
SELECT
  order_id,
  COUNT(*) AS items_in_order
FROM thelook_copy.order_items
GROUP BY 1
ORDER BY items_in_order DESC;

-- Are all products stocked?
SELECT
  COUNT(DISTINCT p.id) AS products,
  COUNT(DISTINCT i.product_id) AS stocked_products
FROM thelook_copy.products p
LEFT JOIN thelook_copy.inventory_items i
  ON p.id = i.product_id;

-- Do all purchasers have a purchase event?
SELECT
  COUNT(DISTINCT o.user_id) AS users_with_orders,
  COUNT(DISTINCT e.user_id) AS users_with_purchase_event
FROM stg_orders o
LEFT JOIN stg_events e
  ON o.user_id = e.user_id
 AND e.event_type = 'purchase';

-- Is orders.num_of_item consistent with order_items?
SELECT
  COUNT(*) AS mismatched_orders
FROM (
  SELECT
    o.order_id,
    o.num_of_item,
    COUNT(oi.id) AS order_item_count
  FROM stg_orders o
  LEFT JOIN stg_order_items oi USING (order_id)
  GROUP BY 1,2
)
WHERE num_of_item != order_item_count;

-- Are there duplicate sessions?
SELECT
  session_id,
  COUNT(*) AS events
FROM stg_events
GROUP BY session_id
HAVING COUNT(*) > 1
LIMIT 10;
