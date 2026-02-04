# ucu-workshop

```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
dbt init
```

Desired authentication method option (enter a number): 1  
project (GCP project id): ucu-sandbox  
dataset (the name of your dbt dataset): dbt_thelook  
threads (1 or more): 4


| Layer        | Purpose                       |
| ------------ | ----------------------------- |
| staging      | clean raw data, rename fields |
| intermediate | apply business logic          |
| marts        | final metrics for BI          |


```
models/  
├── staging/  
│   ├── stg_users.sql  
│   ├── stg_orders.sql  
│   └── stg_events.sql  
├── intermediate/  
│   ├── int_order_financials.sql  
│   └── int_user_cohorts.sql  
└── marts/  
    ├── mart_ecommerce_metrics.sql  
    └── mart_marketing_metrics.sql  
```

```
dbt run
dbt test
dbt docs generate
dbt docs serve
```