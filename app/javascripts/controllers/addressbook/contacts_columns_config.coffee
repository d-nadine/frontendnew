Radium.ContactColumnsConfig = Ember.Mixin.create
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
      }]
      avatar: true
      checked: true
      sortOn: "name"
      component: 'editable-field'
    }
  ])

  columns: Ember.A([
    {
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
      }],
      actions: [
        name: "saveEmail"
        value: "saveEmail"
      ]
      checked: true
      sortOn: "email"
      component: 'editable-field'
    }
    {
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
      }],
      actions: [
        {
          name: "saveCompanyName"
          value: "saveCompanyName"
        }
      ]
      context: "company"
      checked: true
      sortOn: "company"
      component: 'autocomplete-editable-field'
    }
    {
      classNames: "events"
      heading: "Events"
      binding: "activityTotal"
      checked: true
      sortOn: "activity_total"
    }
    {
      classNames: "inactive"
      heading: "Inactive"
      binding: "daysInactive"
      checked: true
      sortOn: "last_activity_at"
    }
    {
      classNames: "next-task"
      heading: "Next Task"
      route: "calendar.task"
      context: "nextTask"
      checked: true
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
      classNames: "next-task-date"
      heading: "Next Task Date"
      binding: "nextTaskDateDisplay"
      checked: true
      sortOn: "next_task_date"
    }
    {
      classNames: "assign"
      heading: "Assigned To"
      component: "assignto-picker"
      bindings: [
        {name: "assignedTo", value: "assignedTo"},
        {name: "assignees", value: "assignees"},
        {name: "contact", value: "contact"},
      ]
      checked: true
    }
    {
      classNames: "last-activity"
      heading: "Last Activity"
      component: "render-activity"
      bindings: [
        {name: "model", value: "model.activities.firstObject"}
      ]
    }
    {
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
      actions: [
        {
          name: 'saveCity'
          value: 'saveCity'
          static: true
        }
      ]
      sortOn: "city"
      component: 'editable-field'
    }
    {
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
      }
      ],
      actions: [
        {
          name: 'savePhone'
          value: 'savePhone'
          static: true
        }
      ]
      sortOn: "phone"
      component: 'editable-field'
    }
    {
      classNames: "source"
      heading: "Source"
      binding: "source"
      sortOn: "source"
    }
    {
      classNames: "added"
      heading: "Added"
      binding: "added"
      sortOn: "created_at"
    }
    {
      classNames: "deals-closed-total"
      heading: "Deals Closed"
      binding: "dealsClosedTotal"
      sortOn: "deals_closed_total"
    }
    {
      classNames: "deals-total"
      heading: "Deals Total"
      binding: "dealsTotal"
      sortOn: "deals_closed_total_value"
    }
    {
      classNames: "tags"
      heading: "Lists"
      bindings: [
        {name: "model", value: "model"}
      ]
      component: "tag-picker"
    }
    {
      classNames: "status"
      heading: "Status"
      binding: "status"
      sortOn: "status"
    }
    {
      classNames: "events-seven"
      heading: "Events in last 7 days"
      binding: "activitySevenDaysTotal"
      sortOn: "activity_seven_days_total"
    }
    {
      classNames: "events-thirty"
      heading: "Events in last 30 days"
      binding: "activityThirtyDaysTotal"
      sortOn: "activity_thirty_days_total"
    }
  ])