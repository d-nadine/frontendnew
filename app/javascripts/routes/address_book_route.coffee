require 'mixins/routes/bulk_action_events_mixin'

Radium.AddressbookRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    addressBookProxy = Radium.AddressBookArrayProxy.create
      currentUser: @controllerFor('currentUser').get('model')

    addressBookProxy.load()

    addressBookProxy
