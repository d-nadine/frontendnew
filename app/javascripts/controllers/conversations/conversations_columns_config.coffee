Radium.ConversationsColumnsConfig = Ember.Mixin.create
  fixedColumns: Ember.A([
    {
      heading: 'Contact'
      classNames: 'email-sender'
      bindings: [{
        name: "contact",
        value: "model.contact"
      },
      {
        name: "linkAction",
        value: "showContactDrawer",
        static: true
      }
      ]
      component: 'contact-link'
    }
  ])
  columns: Ember.A([
    {
      id: "assign"
      classNames: "assign"
      heading: "Assigned To"
      component: "assignto-picker"
      bindings: [
        {name: "assignedTo", value: "model.contact.user"},
        {name: "assignees", value: "assignees"},
        {name: "model", value: "model.contact"},
        {name: "parent", value: "table.targetObject"}
      ]
    }
    {
      id: "next-task"
      classNames: "next-task"
      heading: "Next Task"
      route: "calendar.task"
      context: "nextTask"
      bindings: [{
        name: "model"
        value: "model.contact"
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
      id: 'email-link'
      classNames: "subject"
      heading: 'Subject'
      bindings: [{
        name: "model",
        value: "model"
      }]
      component: 'thread-link'
    }
    {
      id: "received"
      classNames: "received"
      heading: "Received"
      bindings: [{
        name: "date",
        value: "model.time"
      }]
      component: 'human-date'
    }
    {
      id: "actions"
      heading: "Actions"
      classNames: "choose text-center"
      bindings: [
        {name: "model", value: "model"}
        {name: "parent", value: "table.targetObject"}]
      component: 'conversation-actions'
    }
  ])
