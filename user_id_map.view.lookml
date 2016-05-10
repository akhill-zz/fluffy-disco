- view: user_id_map
## By laying out every possible row where a user_id and/or anonymous_id could co-exist, we create the first step of mapping a universal_user_id.

  derived_table:
    sql_trigger_value: SELECT FLOOR(EXTRACT(EPOCH FROM GETDATE()) / (2*60*60)) ## rebuilds every 2 hours
    sortkeys: [anonymous_id]
    distkey: anonymous_id
    
    sql: |
      SELECT
        tstamp AS timestamp
        , user_id AS user_id
        , anonymous_id AS anonymous_id

      FROM 
        public.t_log
        
      WHERE
        log_category = 'EVENT'

  fields:

# Dimensions #

  - dimension_group: timestamp
    type: time
    timeframes: [date, time]
    sql: ${TABLE}.timestamp

  - dimension: user_id
    sql: ${TABLE}.user_id
    
  - dimension: anonymous_id
    sql: ${TABLE}.anonymous_id
        

# Measures #

  - measure: count
    type: count
    
  - measure: count_distinct_anonymous_id
    type: count_distinct
    sql: ${anonymous_id}

  - measure: count_distinct_user_id
    type: count_distinct
    sql: ${user_id}
    
  - measure: count_overlap
    type: number
    sql: COUNT(DISTINCT CASE WHEN ${anonymous_id} IS NOT NULL AND ${user_id} IS NOT NULL THEN (${anonymous_id} || ${user_id}) END)