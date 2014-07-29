Radium.AddressbookRoute = Radium.Route.extend({
  redirect: ->
    @transitionTo 'addressbook.people'
})
