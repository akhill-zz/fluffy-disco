- view: t_log_old
  sql_table_name: public.t_log_old
  fields:

  - dimension: adgroup
    type: string
    sql: ${TABLE}.adgroup

  - dimension: anonymous_id
    type: string
    sql: ${TABLE}.anonymous_id

  - dimension: app_build
    type: string
    sql: ${TABLE}.app_build

  - dimension: app_version
    type: string
    sql: ${TABLE}.app_version

  - dimension: browser_id
    type: string
    sql: ${TABLE}.browser_id

  - dimension: button_copy
    type: string
    sql: ${TABLE}.button_copy

  - dimension: chat_item_id
    type: string
    sql: ${TABLE}.chat_item_id

  - dimension: collection_id
    type: string
    sql: ${TABLE}.collection_id

  - dimension: context
    type: string
    sql: ${TABLE}.context

  - dimension: device_family
    type: string
    sql: ${TABLE}.device_family

  - dimension: error
    type: string
    sql: ${TABLE}.error

  - dimension: event
    type: string
    sql: ${TABLE}.event

  - dimension: event_capture_source
    type: string
    sql: ${TABLE}.event_capture_source

  - dimension: event_id
    type: number
    sql: ${TABLE}.event_id

  - dimension: event_type
    type: string
    sql: ${TABLE}.event_type

  - dimension: event_url
    type: string
    sql: ${TABLE}.event_url

  - dimension: event_url_path
    type: string
    sql: ${TABLE}.event_url_path

  - dimension: event_url_search
    type: string
    sql: ${TABLE}.event_url_search

  - dimension: event_x
    type: number
    sql: ${TABLE}.event_x

  - dimension: event_y
    type: number
    sql: ${TABLE}.event_y

  - dimension: http_method
    type: string
    sql: ${TABLE}.http_method

  - dimension: http_request_body
    type: string
    sql: ${TABLE}.http_request_body

  - dimension: index_set
    type: string
    sql: ${TABLE}.index_set

  - dimension: index_value
    type: number
    sql: ${TABLE}.index_value

  - dimension: input_text
    type: string
    sql: ${TABLE}.input_text

  - dimension: ip
    type: string
    sql: ${TABLE}.ip

  - dimension: ip_city
    type: string
    sql: ${TABLE}.ip_city

  - dimension: ip_country
    type: string
    sql: ${TABLE}.ip_country

  - dimension: ip_dma_code
    type: string
    sql: ${TABLE}.ip_dma_code

  - dimension: ip_latitude
    type: number
    sql: ${TABLE}.ip_latitude

  - dimension: ip_longitude
    type: number
    sql: ${TABLE}.ip_longitude

  - dimension: ip_metro_code
    type: string
    sql: ${TABLE}.ip_metro_code

  - dimension: ip_postal_code
    type: string
    sql: ${TABLE}.ip_postal_code

  - dimension: ip_region
    type: string
    sql: ${TABLE}.ip_region

  - dimension: is_bot
    type: yesno
    sql: ${TABLE}.is_bot

  - dimension: is_internal_user
    type: yesno
    sql: ${TABLE}.is_internal_user

  - dimension: link_url
    type: string
    sql: ${TABLE}.link_url

  - dimension: log_category
    type: string
    sql: ${TABLE}.log_category

  - dimension: log_command
    type: string
    sql: ${TABLE}.log_command

  - dimension: log_env
    type: string
    sql: ${TABLE}.log_env

  - dimension: log_filename
    type: string
    sql: ${TABLE}.log_filename

  - dimension: log_host
    type: string
    sql: ${TABLE}.log_host

  - dimension: log_level
    type: string
    sql: ${TABLE}.log_level

  - dimension: log_line
    type: string
    sql: ${TABLE}.log_line

  - dimension: log_message
    type: string
    sql: ${TABLE}.log_message

  - dimension: log_status
    type: string
    sql: ${TABLE}.log_status

  - dimension: log_time
    type: number
    sql: ${TABLE}.log_time

  - dimension: log_uuid
    type: string
    sql: ${TABLE}.log_uuid

  - dimension: order_id
    type: string
    sql: ${TABLE}.order_id

  - dimension: origin
    type: string
    sql: ${TABLE}.origin

  - dimension: os_family
    type: string
    sql: ${TABLE}.os_family

  - dimension: os_version
    type: string
    sql: ${TABLE}.os_version

  - dimension: page_title
    type: string
    sql: ${TABLE}.page_title

  - dimension: product_id
    type: string
    sql: ${TABLE}.product_id

  - dimension: recommendation_item_id
    type: string
    sql: ${TABLE}.recommendation_item_id

  - dimension: referrer
    type: string
    sql: ${TABLE}.referrer

  - dimension: referrer_domain
    type: string
    sql: ${TABLE}.referrer_domain

  - dimension: referring_view
    type: string
    sql: ${TABLE}.referring_view

  - dimension: request_id
    type: string
    sql: ${TABLE}.request_id

  - dimension: screen_res_h
    type: number
    sql: ${TABLE}.screen_res_h

  - dimension: screen_res_w
    type: number
    sql: ${TABLE}.screen_res_w

  - dimension: session_id
    type: string
    sql: ${TABLE}.session_id

  - dimension: status_code
    type: number
    sql: ${TABLE}.status_code

  - dimension_group: ts_inserted
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.ts_inserted

  - dimension_group: tstamp
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.tstamp

  - dimension: ua_family
    type: string
    sql: ${TABLE}.ua_family

  - dimension: ua_version
    type: string
    sql: ${TABLE}.ua_version

  - dimension: user_id
    type: string
    sql: ${TABLE}.user_id

  - dimension: useragent
    type: string
    sql: ${TABLE}.useragent

  - dimension: utm_campaign
    type: string
    sql: ${TABLE}.utm_campaign

  - dimension: utm_content
    type: string
    sql: ${TABLE}.utm_content

  - dimension: utm_medium
    type: string
    sql: ${TABLE}.utm_medium

  - dimension: utm_source
    type: string
    sql: ${TABLE}.utm_source

  - dimension: utm_term
    type: string
    sql: ${TABLE}.utm_term

  - dimension: value
    type: string
    sql: ${TABLE}.value

  - dimension: value_context
    type: string
    sql: ${TABLE}.value_context

  - dimension: view
    type: string
    sql: ${TABLE}.view

  - dimension: window_res_h
    type: number
    sql: ${TABLE}.window_res_h

  - dimension: window_res_w
    type: number
    sql: ${TABLE}.window_res_w

  - measure: count
    type: count
    drill_fields: [log_filename]

