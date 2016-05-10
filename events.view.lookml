- view: events
# This persistent derived table groups all page() & track() events for a unique universal_user_id, 
# as well as grabbing the time between an event and the event immediately preceding it to determine idle time
# which will be used for session definition in sessions PDT. Sessions and event_facts build from this PDT.
# Nested subqueries decode encoded URLs which have become a growing % of our referrer and landing page urls, primarily owed to facebook

  derived_table:
    sql_trigger_value: SELECT FLOOR(EXTRACT(EPOCH FROM GETDATE()) / (2*60*60)) ## rebuilds every 2 hours
    sortkeys: [event_id]
    distkey: universal_user_id
    
    sql: |
      SELECT
        *
        , LAG(event_name, 1 RESPECT NULLS) OVER(PARTITION BY universal_user_id ORDER BY original_timestamp ASC) AS previous_event_name
        , LEAD(event_name, 1 RESPECT NULLS) OVER(PARTITION BY universal_user_id ORDER BY original_timestamp ASC) AS next_event_name
        , DATEDIFF(minutes, LAG(original_timestamp) OVER(PARTITION BY universal_user_id ORDER BY original_timestamp), original_timestamp) AS idle_time_minutes /*calculates the # of minutes since the prior track() or page() event from below UNION*/

      FROM

              (SELECT
                t.event_id
                , t.event_capture_source AS context_event_capture_source
                , COALESCE(u.universal_user_id,t.user_id,t.anonymous_id) AS universal_user_id
                , u.universal_user_id AS universal_user_id_mapped
                , t.anonymous_id
                , t.user_id
                , t.tstamp AS original_timestamp
                , t.event AS event
                , t.page_url_path AS context_page_path
                , t.referrer AS raw_referrer
                , REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(t.referrer,'%3A',':'),'%2F','/'),'%3F','?'),'%26','&'),'%3D','='),'%2A','*'),'%5F','_'),'%5f','_'),'%7B','{'),'%7D','}'),'%20',' ') AS referrer
                , t.page_url AS raw_event_url
                , REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(t.page_url,'%3A',':'),'%2F','/'),'%3F','?'),'%26','&'),'%3D','='),'%2A','*'),'%5F','_'),'%5f','_'),'%7B','{'),'%7D','}'),'%20',' ') AS event_url
                , t.page_url_search AS event_url_query_string
                , t.useragent
                , t.ip AS ip_address
                , t.app_build AS app_version_build
                , t.app_version
                , t.context
                , t.view
                , t.event_type AS type
                , t.value_context
                , t.value
                , t.index_set
                , t.index_value
                , t.input_text
                , t.request_id
                , t.product_id
                , t.recommendation_item_id AS recommendation_id
                , t.button_copy
                , t.utm_medium AS medium
                , t.utm_source AS source
                , t.utm_campaign AS name
                , t.utm_content AS content
                , t.utm_term AS term
                , t.adgroup
/*                , o.experiment_id
                , o.experiment_name
                , o.variation_id
                , o.variation_name
                , t.context_device_advertising_id AS idfa
                , t.context_device_id AS device_id
                , t.context_properties_input_text_relationship
*/
                    
              FROM
                public.t_log AS t
                LEFT JOIN ${universal_user_id_map.SQL_TABLE_NAME} u ON u.anonymous_id = t.anonymous_id
/*                LEFT JOIN ${optimizely_experiment_events.SQL_TABLE_NAME} o ON o.event_id = t.event_id */
      
              WHERE
                event NOT IN ('item', 'collection_published', 'collection_removed', 'waitlist', 'request', 'user', 'product', 'order', 'collection', 'vendor', 'seo') t /*Excluding specific events that get built out using event-specific tables UNION'd below*/
      

              ) AS e 
                      
  fields:

## Dimensions ##

  - dimension: event_id
    primary_key: true
    hidden: true

  - dimension: universal_user_id
    hidden: true

  - dimension: universal_user_id_mapped
    description: 'UUID mapped to an anonymous_id'

  - dimension: user_id

  - dimension: anonymous_id

  - dimension: user_id_mapped
    description: 'Yes if anonymous_id has a user ID mapped to it'
    type: yesno
    sql: ${universal_user_id_mapped} IS NULL

  - dimension_group: original_timestamp
    hidden: true
    type: time
    timeframes: [time]
## To enable join of event_facts to events on 3 dimensions...

  - dimension: idle_time_minutes
    description: '# of minutes since the previous event'
    type: number

  - dimension: event
    hidden: true

  - dimension: page_name

  - dimension: context
  
  - dimension: view
  
  - dimension: type

  - dimension: value_context

  - dimension: value

  - dimension: index_set

  - dimension: index_value

  - dimension: input_text

  - dimension: request_id
  
  - dimension: product_id
  
  - dimension: recommendation_id
  
  - dimension: button_copy
    sql: ${TABLE}.context_properties_button_copy

  - dimension: is_app_event
    type: yesno
    sql: ${app_version} IS NOT NULL OR ${app_version_build} IS NOT NULL OR (LOWER(${useragent}) LIKE '%iphone%' AND ${useragent} NOT LIKE '%Safari%' AND ${useragent} NOT LIKE '%Chrome%' AND ${useragent} NOT LIKE '%Pinterest%' AND ${useragent} NOT LIKE '%iPad%' AND ${useragent} NOT LIKE '%Twitter for iPhone%' AND ${useragent} NOT LIKE '%Instagram%' AND ${useragent} NOT LIKE '%FBAN%')

  - dimension: app_version
  
  - dimension: app_version_build

  - dimension: context_library_name
  
  - dimension: context_event_capture_source

  - dimension: referring_url
    description: 'The URL that immediately preceded the URL this event was recorded on'
    sql: ${TABLE}.referrer

  - dimension: context_page_path

  - dimension: raw_referrer
    sql: ${TABLE}.raw_referrer
  
  - dimension: event_url_query_string
    hidden: true

  - dimension: user_click_waitlist_join_event
    type: yesno
    hidden: true
    sql: ${TABLE}.event = 'user_click_waitlist_join'

  - dimension: useragent

  - dimension: is_internal_ip_address
    type: yesno
    sql: ${TABLE}.ip_address IN ('96.89.239.217', '66.30.112.58', '64.80.225.29', '50.177.139.72', '73.227.252.18', '65.96.147.123') OR ${TABLE}.event_url IN ('https://prod-test.tryscratch.com/', 'https://test.tryscratch.com/', 'https://prod-test.helloshopper.com/', 'https://test.helloshopper.com/') OR ${referring_url} IN ('https://prod-test.tryscratch.com/', 'https://test.tryscratch.com/', 'https://prod-test.helloshopper.com/', 'https://test.helloshopper.com/')
  
  - dimension: previous_event_name
  
  - dimension: next_event_name

  -- - dimension: idfa
  
  -- - dimension: device_id

  -- - dimension: experiment_name

  -- - dimension: variation_name

  -- - dimension: input_text_relationship
  --   sql: ${TABLE}.context_properties_input_text_relationship

  -- - measure: count_idfa
  --   type: count_distinct
  --   sql: ${idfa}
  --   drill_fields: detail*
