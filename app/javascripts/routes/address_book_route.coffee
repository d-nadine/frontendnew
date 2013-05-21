require 'routes/mixins/email_events_mixin'

Radium.AddressbookRoute = Radium.Route.extend Radium.EmailEventsMixin,
  model: ->
    addressBookProxy = Radium.AddressBookArrayProxy.create
      currentUser: @controllerFor('currentUser').get('model')

    addressBookProxy.load()

    addressBookProxy
