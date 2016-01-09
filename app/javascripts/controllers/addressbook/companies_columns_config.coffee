Radium.CompaniesColumnConfig = Ember.Mixin.create
  SAVED_COLUMNS: "addressbook_companies_saved_checked_columns"
  initialColumns: ['email', 'website', 'assign', 'lists']
  fixedColumns: Ember.A([
    {
      classNames: "name"
      heading: "Name"
      route: "company"
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
        value: "showCompanyDrawer",
        static: true
      }]
      avatar: true
      checked: true
      sortOn: "name"
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
        value: "showCompanyDrawer",
        static: true
      }],
      component: 'editable-field'
    },
    {
      id: "website"
      group: "details"
      classNames: "website"
      heading: "Website"
      bindings: [{
        name: "model",
        value: "model"
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
    },
    {
      id: "assign"
      classNames: "assign"
      group: "actions"
      heading: "Assigned To"
      component: "assignto-picker"
      bindings: [
        {name: "assignedTo", value: "model.user"},
        {name: "assignees", value: "assignees"},
        {name: "model", value: "model"},
        {name: "parent", value: "table.targetObject"}
      ]
    },
    {
      id: "street"
      group: "details"
      classNames: "city"
      heading: "Street"
      bindings: [{
        name: "model",
        value: "model"
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
        value: "model"
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
      component: 'editable-field'
    },
    {
      id: "state"
      group: "details"
      classNames: "city"
      heading: "State"
      bindings: [{
        name: "model",
        value: "model"
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
        value: "model"
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
    },
    {
      id: "added"
      group: "activity"
      classNames: "added"
      heading: "Added"
      binding: "added"
      sortOn: "created_at"
    }
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
    },
    {
      id: "sector"
      group: "details"
      classNames: "phone"
      heading: "Sector"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Sector",
        static: true
      },
      {
        name: "bufferKey",
        value: "sector"
        static: true
      }]
      component: 'editable-field'
    },
    {
      id: "employees"
      group: "details"
      classNames: "phone"
      heading: "Employees"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Employees",
        static: true
      },
      {
        name: "bufferKey",
        value: "employees"
        static: true
      }]
      component: 'editable-field'
    },
    {
      id: "inactive"
      group: "activity"
      classNames: "inactive"
      heading: "Inactive"
      binding: "daysInactive"
      sortOn: "last_activity_at"
    }
    {
      id: "industry"
      group: "details"
      classNames: "phone"
      heading: "Industry"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Industry",
        static: true
      },
      {
        name: "bufferKey",
        value: "industry"
        static: true
      }]
      component: 'editable-field'
    },
    {
      id: "industry-group"
      group: "details"
      classNames: "phone"
      heading: "Industry Group"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Industry Group",
        static: true
      },
      {
        name: "bufferKey",
        value: "industryGroup"
        static: true
      }]
      component: 'editable-field'
    },
    {
      id: "subindustry"
      group: "details"
      classNames: "phone"
      heading: "Subindustry"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Subindustry",
        static: true
      },
      {
        name: "bufferKey",
        value: "subindustry"
        static: true
      }]
      component: 'editable-field'
    }
    ]
  )
