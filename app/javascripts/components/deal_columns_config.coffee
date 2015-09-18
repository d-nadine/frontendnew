Radium.DealColumnsConfig = Ember.Mixin.create
  SAVED_COLUMNS: "deal_saved_checked_columns"
  initialColumns: ['assign', "change-status", "status-change-date", "next-task", "next-task-date"]
  fixedColumns: Ember.A([
    {
      classNames: "list-name"
      heading: "Name"
      dynamicHeading: true
      route: "deal"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Name",
        static: true
      },
      {
        name: "bufferKey",
        value: "name"
        static: true
      },
      {
        name: "routeAction",
        value: "showDealDrawer",
        static: true
      }]
      checked: true
      sortOn: "name"
      context: "model"
      component: 'editable-field'
    }
  ])

  columns: Ember.A([
    {
      id: "assign"
      classNames: "assign"
      heading: "Assigned To"
      component: "assignto-picker"
      bindings: [
        {name: "assignedTo", value: "model.user"},
        {name: "assignees", value: "assignees"},
        {name: "model", value: "model"},
        {name: "parent", value: "table.targetObject"}
      ]
    }
    {
      id: "last-activity"
      classNames: "last-activity"
      heading: "Last Activity"
      component: "render-activity"
      bindings: [
        {name: "model", value: "model.activities.firstObject"}
      ]
    }
    {
      id: "change-status"
      classNames: "change-status"
      heading: "Change Status"
      bindings: [
        {name: "deal", value: "model"},
        {name: "parent", value: "table.targetObject"}
      ]
      component: "change-liststatus"
    }
    {
      id: "status-change-date"
      classNames: "status-change-date"
      heading: "Last Status Change"
      binding: "daysInCurrentState"
      sortOn: "status_last_changed"
    }
    {
      id: "next-task"
      classNames: "next-task"
      heading: "Next Task"
      route: "calendar.task"
      context: "nextTask"
      bindings: [{
        name: "model"
        value: "model"
      }
      {
        name: "currentUser"
        value: "currentUser"
      }
      {
        name: "tomorrow"
        value: "tomorrow"
      }]
      component: "next-task"
    }
    {
      id: "next-task-date"
      classNames: "next-task-date"
      heading: "Next Task Date"
      binding: "nextTaskDateDisplay"
      sortOn: "next_task_date"
    }
    {
      id: "value"
      classNames: "deal-value"
      heading: "Value"
      bindings: [{
        name: "value"
        value: "model.value"
      },
      {
        name: "model"
        value: "model"
      },
      {
        name: "saveAction",
        value: "saveDealValue",
        static: true
      }
      ]
      component: "currency-control"
    }
  ])
