- view: universal_user_id_map
## This PDT maps all possible combinations of anonymous IDs to associated user IDs. We SELECT from 
## the user_id_map PDT, and then join it back on to generate a row for each unique combination that we can then
## query for a 'universal_user_id' that can traverse forward and backwards.
## Essential piece here is to SELECT where anonymous_id *AND* user_id IS NOT NULL so that we are able to identify
## each possible match between an anonymous_id and a user_id. Then, SELECT'ing 'DISTINCT' from this
## first table creates 1 and only 1 row for each match. There are no rows for anonymous_id's we cannot match
## to a user_id.

  derived_table:

    sql_trigger_value: SELECT COUNT(1) FROM ${user_id_map.SQL_TABLE_NAME}
    sortkeys: [anonymous_id]
    distkey: universal_user_id

    sql: |
      SELECT
        DISTINCT uim_distinct.anonymous_id
        , COALESCE(uim.user_id_mapped,uim_distinct.user_id,uim_distinct.anonymous_id) AS universal_user_id
        , COALESCE(uim.user_id_mapped,uim_distinct.user_id) AS user_id
        
      FROM
        ${user_id_map.SQL_TABLE_NAME} uim_distinct
        
      LEFT JOIN
        (SELECT
          user_id AS user_id_mapped
          , anonymous_id AS anonymous_id_mapped
          
        FROM
          ${user_id_map.SQL_TABLE_NAME}
          
        WHERE
          anonymous_id IS NOT NULL
          AND user_id IS NOT NULL
          AND user_id NOT LIKE '%simplelogin%'
          AND user_id <> 'frontend') AS uim ON uim.anonymous_id_mapped = uim_distinct.anonymous_id

  fields:

# Dimensions #

  - dimension: anonymous_id
    sql: ${TABLE}.anonymous_id
    
  - dimension: universal_user_id
    sql: ${TABLE}.universal_user_id
    
  - dimension: user_id
    sql: ${TABLE}.user_id
    
  - dimension: no_user_id
    type: yesno
    sql: ${universal_user_id} <> ${user_id}

# Measures #

  - measure: count
    type: count
    
  - measure: count_distinct_anonymous_id
    type: count_distinct
    sql: ${anonymous_id}

  - measure: count_distinct_universal_user_id
    type: count_distinct
    sql: ${universal_user_id}