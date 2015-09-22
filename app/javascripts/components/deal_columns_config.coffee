Radium.DealColumnsConfig = Ember.Mixin.create
  SAVED_COLUMNS: "deal_saved_checked_columns"
  initialContactsColumns: ['assign', "change-status", "status-change-date", "next-task", "next-task-date"]
  initialCompaniesColumns: ['company-name', 'assign', "change-status", "status-change-date", "next-task", "next-task-date"]
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
      context: "model"
      component: 'editable-field'
    }
  ])

  contactsColumns: Ember.A([
    {
      id: "assign"
      group: "actions"
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
      bindings: [
        {name: "model", value: "model.activities.firstObject"}
      ]
      component: "render-activity"
    }
    {
      id: "change-status"
      group: "actions"
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
      group: "activity"
      classNames: "status-change-date"
      heading: "Last Status Change"
      binding: "daysInCurrentState"
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
      id: "next-task-date"
      group: "activity"
      classNames: "next-task-date"
      heading: "Next Task Date"
      binding: "nextTaskDateDisplay"
    }
    {
      id: "deal-value"
      group: "details"
      classNames: "deal-value"
      heading: "value"
      bindings: [
        {name: "value", value: "model.value"}
        {name: "model", value: "model"}
        {name: "saveAction", value: "saveDealValue", static: true}
      ]
      component: "currency-control"
    }
  ])

  companiesColumns: Ember.A([
    {
      id: "company-name"
      group: "details"
      classNames: "company"
      heading: "Company-name"
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
        value: "company.name"
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
      component: 'autocomplete-editable-field'
    }
    {
      id: "assign"
      group: "actions"
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
      id: "website"
      group: "details"
      classNames: "website"
      heading: "Website"
      bindings: [{
        name: "model",
        value: "model.company"
      }
      {
        name: "placeholder"
        value: "Add website"
        static: true
      },
      {
        name: "bufferKey"
        value: "website"
        static: true
      },
      {
        name: "externalUrl"
        value: true
        static: true
      }
      {
        name: "notRoutable"
        value: true
        static: true
      }
      ],
      component: 'editable-field'
    }
    {
      id: "last-activity"
      group: "activity"
      classNames: "last-activity"
      heading: "Last Activity"
      bindings: [
        {name: "model", value: "model.activities.firstObject"}
      ]
      component: "render-activity"
    }
    {
      id: "change-status"
      group: "actions"
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
      group: "activity"
      classNames: "status-change-date"
      heading: "Last Status Change"
      binding: "daysInCurrentState"
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
      id: "next-task-date"
      group: "activity"
      classNames: "next-task-date"
      heading: "Next Task Date"
      binding: "nextTaskDateDisplay"
    }
    {
      id: "deal-value"
      group: "details"
      classNames: "deal-value"
      heading: "value"
      bindings: [
        {name: "value", value: "model.value"}
        {name: "model", value: "model"}
        {name: "saveAction", value: "saveDealValue", static: true}
      ]
      component: "currency-control"
    }
  ])
