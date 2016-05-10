- connection: marion

- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards

- explore: events
  from: t_log

- explore: requests