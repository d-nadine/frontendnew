Radium.AddressbookRoute = Radium.Route.extend
  model: ->
    addressBookProxy = Radium.AddressBookArrayProxy.create
      currentUser: @controllerFor('currentUser').get('model')

    addressBookProxy.load()

    addressBookProxy
