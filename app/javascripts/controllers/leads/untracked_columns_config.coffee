Radium.UntrackedColumnsConfig = Ember.Mixin.create
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
      sortOn: "email"
      component: 'editable-field'
    }
    {
      id: "untracked-actions"
      classNames: "untracked-actions"
      component: "untracked-actions"
      bindings: [{
        name: "model"
        value: "model"
      }]
      actions: [
        {
          name: "track"
          value: "track"
        }
      ]
    }
  ])

