WITH events_clean AS (
  SELECT
    user_id,
    session_id,
    event_type,
    DATE(created_at) AS event_date
  FROM thelook_copy.events
),

first_seen AS (
  SELECT
    user_id,
    MIN(event_date) AS first_date,
    DATE_TRUNC(MIN(event_date), MONTH) AS cohort_month
  FROM events_clean
  GROUP BY 1
),

events_cohort AS (
  SELECT
    e.*,
    f.cohort_month
  FROM events_clean e
  JOIN first_seen f
    ON e.user_id = f.user_id
)

SELECT
  cohort_month,
  event_date,
  COUNT(DISTINCT user_id) AS active_users,
  COUNT(DISTINCT session_id) AS sessions,
  COUNTIF(event_type = 'product_view') AS product_views,
  COUNTIF(event_type = 'add_to_cart') AS add_to_carts,
  COUNTIF(event_type = 'purchase') AS purchases,
  SAFE_DIVIDE(
    COUNTIF(event_type = 'add_to_cart'),
    COUNTIF(event_type = 'product_view')
  ) AS view_to_cart_rate,
  SAFE_DIVIDE(
    COUNTIF(event_type = 'purchase'),
    COUNTIF(event_type = 'add_to_cart')
  ) AS cart_to_purchase_rate
FROM events_cohort
GROUP BY 1, 2;
