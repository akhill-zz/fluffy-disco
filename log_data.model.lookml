- connection: marion
- scoping: true

- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards

#-------------------------------------------------------------
- explore: t_log

- explore: events

- explore: requests

- explore: user_id_map

- explore: universal_user_id_map