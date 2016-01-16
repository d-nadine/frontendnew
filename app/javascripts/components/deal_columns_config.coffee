Radium.DealColumnsConfig = Ember.Mixin.create
  SAVED_COLUMNS: "deal_saved_checked_columns"
  initialContactsColumns: ["contact-email", "assign", "change-status", "status-change-date"]
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
      id: "contact-name"
      group: "details"
      classNames: "name"
      heading: "Contact Name"
      route: "contact"
      bindings: [{
        name: "model",
        value: "model.contact"
      }
      {
        name: "placeholder",
        value: "contact name",
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
      },
      {
        name: "nullModelType",
        value: Radium.Contact,
        static: true
      },
      {
        name: "deal"
        value: "model"
      }],
      actions: [{
        name: "afterSave"
        value: "afterContactSave"
      }
      ]
      avatar: true
      checked: true
      context: "model"
      component: 'editable-field'
    }
    {
      id: "contact-email"
      group: "details"
      classNames: "email"
      heading: "Contact Email"
      route: "contact"
      bindings: [{
        name: "model",
        value: "model.contact"
      }
      {
        name: "placeholder",
        value: "contact's email'",
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
      }
      {
        name: "nullModelType",
        value: Radium.Contact,
        static: true
      },
      {
        name: "nullModelType",
        value: Radium.Contact,
        static: true
      },
      {
        name: "deal"
        value: "model"
      }],
      actions: [{
        name: "afterSave"
        value: "afterContactSave"
      }]
      component: 'editable-field'
    }
    {
      id: "inactive"
      group: "activity"
      classNames: "inactive"
      heading: "Inactive"
      binding: "daysInactive"
    }
    {
      id: "street"
      group: "address"
      classNames: "street"
      heading: "Street"
      bindings: [{
        name: "model",
        value: "model.contact"
      }
      {
        name: "placeholder",
        value: "Add street",
        static: true
      },
      {
        name: "bufferKey",
        value: "street"
        static: true
      }
      ],
      component: 'editable-field'
    }
    {
      id: "city"
      group: "address"
      classNames: "city"
      heading: "City"
      bindings: [{
        name: "model",
        value: "model.contact"
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
      component: 'editable-field'
    }
    {
      id: "state"
      group: "address"
      classNames: "state"
      heading: "State"
      bindings: [{
        name: "model",
        value: "model.contact"
      }
      {
        name: "placeholder",
        value: "Add state",
        static: true
      },
      {
        name: "bufferKey",
        value: "state"
        static: true
      }
      ],
      component: 'editable-field'
    }
    {
      id: "zipcode"
      group: "address"
      classNames: "zipcode"
      heading: "Zip Code"
      bindings: [{
        name: "model",
        value: "model.contact"
      }
      {
        name: "placeholder",
        value: "Add zipcode",
        static: true
      },
      {
        name: "bufferKey",
        value: "zipcode"
        static: true
      }
      ],
      component: 'editable-field'
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
      heading: "Value"
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
      heading: "Company Name"
      route: "company"
      bindings: [{
        name: "model",
        value: "model.company"
      }
      {
        name: "placeholder",
        value: "Add Company",
        static: true
      },
      {
        name: "bufferKey",
        value: "name"
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
        name: "nullModelType",
        value: Radium.Company,
        static: true
      },
      {
        name: "deal"
        value: "model"
      }
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
          value: "afterCompanySave"
        }
      ]
      context: "company"
      component: 'autocomplete-editable-field'
    }
    {
      id: "email"
      group: "details"
      classNames: "email"
      heading: "Email"
      route: "contact"
      bindings: [{
        name: "model",
        value: "model.company"
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
        value: "showCompanyDrawer",
        static: true
      }],
      component: 'editable-field'
    }
    {
      id: "inactive"
      group: "activity"
      classNames: "inactive"
      heading: "Inactive"
      binding: "daysInactive"
   },
   {
      id: "primary-contact"
      group: "company",
      classNames: "company",
      heading: "Primary Contact",
      route: "contact",
      bindings: [
        {
          name: "model",
          value: "model"
        },
        {
          name: "deal",
          value: "model"
        }
        {
          name: "bufferKey",
          value: "contact",
          static: true
        },
        {
          name: "scopes",
          value: "contact",
          static: true
        },
        {
          name: "queryKey",
          value: "displayName",
          static: true
        },
        {
          name: "placeholder",
          value: "Add Contact",
          static: true
        },
        {
          name: "saveAction",
          value: "setPrimaryContact",
          static: true
        },
        {
          name: "actionOnly",
          value: true,
          static: true
        },
        {
          name: "routeAction",
          value: "showContactDrawer",
          static: true
        }]
      component: 'autocomplete-editable-field'
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
      component: 'editable-field'
    },
    {
      id: "fax"
      group: "details"
      classNames: "phone"
      heading: "Fax"
      bindings: [{
        name: "model",
        value: "model.company"
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
      component: 'editable-field'
    },
    {
      id: "added"
      group: "activity"
      classNames: "phone"
      heading: "Added"
      binding: "company.added"
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
    },
    {
      id: "street"
      group: "details"
      classNames: "city"
      heading: "Street"
      bindings: [{
        name: "model",
        value: "model.company"
      }
      {
        name: "placeholder",
        value: "Add street",
        static: true
      },
      {
        name: "bufferKey",
        value: "street"
        static: true
      }
      ],
      component: 'editable-field'
    },
    {
      id: "line2"
      group: "details"
      classNames: "city"
      heading: "Line 2"
      bindings: [{
        name: "model",
        value: "model.company"
      }
      {
        name: "placeholder",
        value: "Add line 2",
        static: true
      },
      {
        name: "bufferKey",
        value: "line2"
        static: true
      }
      ],
      component: 'editable-field'
    },
    {
      id: "city"
      group: "details"
      classNames: "city"
      heading: "City"
      bindings: [{
        name: "model",
        value: "model.company"
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
      component: 'editable-field'
    },
    {
      id: "state"
      group: "details"
      classNames: "city"
      heading: "State"
      bindings: [{
        name: "model",
        value: "model.company"
      }
      {
        name: "placeholder",
        value: "Add state",
        static: true
      },
      {
        name: "bufferKey",
        value: "state"
        static: true
      }
      ],
      component: 'editable-field'
    }
    {
      id: "zipcode"
      group: "details"
      classNames: "city"
      heading: "Zipcode/Postcode"
      bindings: [{
        name: "model",
        value: "model.company"
      }
      {
        name: "placeholder",
        value: "Add zipcode/postcode",
        static: true
      },
      {
        name: "bufferKey",
        value: "zipcode"
        static: true
      }
      ],
      component: 'editable-field'
    }
  ])
