require 'mixins/routes/bulk_action_events_mixin'

Radium.AddressbookRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    addressBookProxy = Radium.AddressBookArrayProxy.create
      currentUser: @controllerFor('currentUser').get('model')

    addressBookProxy.load()

    addressBookProxy

Radium.AddressbookCompaniesRoute = Radium.Route.extend
  setupController: ->
    @controllerFor('addressbook').set('model.selectedFilter', 'companies')

Radium.AddressbookTagsRoute = Radium.Route.extend
  setupController: ->
    @controllerFor('addressbook').set('model.selectedFilter', 'tags')

Radium.AddressbookContactsRoute = Radium.Route.extend
  setupController: ->
    @controllerFor('addressbook').set('model.selectedFilter', 'people')
