Radium.ContactColumnsConfig = Ember.Mixin.create
  SAVED_COLUMNS: "contact_saved_checked_columns"
  initialColumns: ['email', 'company', "assign"]
  fixedColumns: Ember.A([
    {
      classNames: "name"
      heading: "Name"
      route: "contact"
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
        value: "showContactDrawer",
        static: true
      }]
      avatar: true
      checked: true
      sortOn: "name"
      context: "model"
      component: 'editable-field'
    }
  ])

  columns: Ember.A([
    {
      id: "email"
      group: "details"
      classNames: "email"
      heading: "Email"
      route: "contact"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Email",
        static: true
      },
      {
        name: "bufferKey",
        value: "email"
        static: true
      },
      {
        name: 'validator',
        value: Radium.EMAIL_REGEX,
        static: true
      },
      {
        name: "routeAction",
        value: "showContactDrawer",
        static: true
      }],
      sortOn: "email"
      component: 'editable-field'
    }
    {
      id: "company"
      group: "company"
      classNames: "company"
      heading: "Company"
      route: "company"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Company",
        static: true
      },
      {
        name: "bufferKey",
        value: "companyName"
        static: true
      },
      {
        name: "queryKey",
        value: "name",
        static: true
      },
      {
        name: "alternativeRoute",
        value: "company",
        static: true
      },
      {
        name: 'scopes'
        value: 'company'
        static: true
      },
      {
        name: "routeAction",
        value: "showCompanyDrawer",
        static: true
      }],
      actions: [
        {
          name: "saveAction"
          value: "saveCompany"
        }
        {
          name: "afterSave"
          value: "afterSaveCompany"
        }
      ]
      context: "company"
      sortOn: "company"
      component: 'autocomplete-editable-field'
    }
    {
      id: "events"
      group: "activity"
      classNames: "events"
      heading: "Events"
      binding: "activityTotal"
      sortOn: "activity_total"
    }
    {
      id: "inactive"
      group: "activity"
      classNames: "inactive"
      heading: "Inactive"
      binding: "daysInactive"
      sortOn: "last_activity_at"
    }
    {
      id: "next-task"
      group: "actions"
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
      group: "activity"
      id: "next-task-date"
      classNames: "next-task-date"
      heading: "Next Task Date"
      binding: "nextTaskDateDisplay"
      sortOn: "next_task_date"
    }
    {
      id: "sharing"
      group: "actions"
      classNames: "sharing"
      heading: "Sharing"
      component: "toggle-switch"
      bindings: [
        {name: "checked", value: "model.isPublic"}
        {name: "parentContext", value: "table.targetObject"}
        {name: "model", value: "model"}
        {name: "dataOn", value: "Shared", static: true}
        {name: "dataOff", value: "Private", static: true}
        {name: "dontPropagate", value: true, static: true}
      ]
      actions: [
        {
          name: 'action'
          value: 'switchShared'
          static: true
        }
      ]
    }
    {
      id: "assign"
      group: "details"
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
      group: "activity"
      classNames: "last-activity"
      heading: "Last Activity"
      component: "render-activity"
      bindings: [
        {name: "model", value: "model.activities.firstObject"}
      ]
    }
    {
      id: "city"
      group: "details"
      classNames: "city"
      heading: "City"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add city",
        static: true
      },
      {
        name: "bufferKey",
        value: "city"
        static: true
      }
      ],
      sortOn: "city"
      component: 'editable-field'
    }
    {
      id: "phone"
      group: "details"
      classNames: "phone"
      heading: "Phone"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Phone",
        static: true
      },
      {
        name: "bufferKey",
        value: "phone"
        static: true
      }]
      sortOn: "phone"
      component: 'editable-field'
    }
    {
      id: "fax"
      group: "details"
      classNames: "fax"
      heading: "Fax"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Fax",
        static: true
      },
      {
        name: "bufferKey",
        value: "fax"
        static: true
      }]
      sortOn: "fax"
      component: 'editable-field'
    }
    {
      group: "details"
      id: "source"
      classNames: "source"
      heading: "Source"
      binding: "source"
      sortOn: "source"
    }
    {
      id: "added"
      group: "activity"
      classNames: "added"
      heading: "Added"
      binding: "added"
      sortOn: "created_at"
    },
    {
      id: "lists"
      group: "actions"
      classNames: "lists"
      heading: "Lists"
      bindings: [
        {name: "model", value: "model"}
        {name: "destination", value: "model.lists"}
        {name: "abortResize", value: true, static: true}
        {name: "addList", value: "addList", static: true}
        {name: "removeList", value: "removeList", static: true}
      ]
      component: "list-autosuggest"
    }
    {
      id: "status"
      group: "actions"
      classNames: "assign stat"
      heading: "Contact Status"
      sortOn: "status"
      bindings: [
        {name: "model", value: "model"}
        {name: "contactStatuses", value: "contactStatuses"}
        {name: "availableStatuses", value: "availableStatuses"}
      ]
      component: "status-picker"
    }
    {
      id: "events-seven"
      group: "activity"
      classNames: "events-seven"
      heading: "Events in last 7 days"
      binding: "activitySevenDaysTotal"
      sortOn: "activity_seven_days_total"
    }
    {
      id: "events-thirty"
      group: "activity"
      classNames: "events-thirty"
      heading: "Events in last 30 days"
      binding: "activityThirtyDaysTotal"
      sortOn: "activity_thirty_days_total"
    }
  ])
