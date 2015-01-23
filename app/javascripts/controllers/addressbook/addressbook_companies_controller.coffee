require "controllers/addressbook/people_mixin"

Radium.AddressbookCompaniesController = Radium.ArrayController.extend Radium.PeopleMixin,
  actions:
    showMore: ->
      return if @get('content.isLoading')
      @get('model').expand()

  needs: ['addressbook', 'users', 'tags']

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
      id: "open-deals"
      classNames: "open-deals"
      heading: "Open Deals"
      binding: "openDeals"
      sortOn: "openDeals"
    }
    {
      id: "assign"
      classNames: "assign"
      heading: "Assigned To"
      component: "assignto-picker"
      bindings: [
        {name: "assignedTo", value: "assignedTo"},
        {name: "assignees", value: "assignees"},
        {name: "company", value: "company"},
      ]
    }]
  )
