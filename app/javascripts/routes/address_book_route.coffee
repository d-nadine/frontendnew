require 'mixins/routes/bulk_action_events_mixin'

Radium.AddressbookRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    addressBookProxy = Radium.AddressBookArrayProxy.create
      currentUser: @controllerFor('currentUser').get('model')

    addressBookProxy.load()

    addressBookProxy

  deactivate: ->
    model = @controllerFor('addressbook').get('model')
    model.destroy()
    model = null
    @currentModel = null

Radium.AddressbookFilterRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  setupController: (controller, model) ->
    addressbookController = @controllerFor('addressbook')
    addressbookController.set 'searchText', ''
    addressbookController.set('model.selectedFilter', model)

  serialize: (filter) ->
    filter: filter

  deserialize: (params) ->
    params.filter

Radium.AddressbookMemberBaseRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  setupController: (controller, model) ->
    addressbookController = @controllerFor('addressbook')
    addressbookController.set 'searchText', ''
    addressbookController.set('currentPage', 1)
    Ember.run =>
      addressbookController.set('model.selectedResource', model)
      addressbookController.trigger 'selectedResourceChanged', model
      addressbookController.set 'model.selectedFilter', 'resource'

    Ember.run.next =>
      addressbookController.set('model.selectedResource', null)

Radium.AddressbookMembersRoute = Radium.AddressbookMemberBaseRoute.extend()

Radium.AddressbookEmployeesRoute = Radium.AddressbookMemberBaseRoute.extend()

