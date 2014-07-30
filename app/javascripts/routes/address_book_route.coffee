Radium.AddressbookRoute = Radium.Route.extend({
  afterModel: ->
    @transitionTo 'addressbook.people'
})
