require 'mixins/routes/bulk_action_events_mixin'

Radium.AddressbookRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    model = @modelFor 'addressbook'

    return model if model

    addressBookProxy = Radium.AddressBookArrayProxy.create
      currentUser: @controllerFor('currentUser').get('model')

    addressBookProxy.load()

    addressBookProxy

  deactivate: ->
    if addressBookContent = @modelFor('addressbook')
      addressBookContent.set('searchText', '')

    @controllerFor('externalcontacts').set 'searchText', ''

Radium.AddressbookFilterRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  model: (params) ->
    params.filter

  setupController: (controller, model) ->
    addressbookController = @controllerFor('addressbook')
    addressbookController.set 'searchText', ''
    Ember.run.next =>
      addressbookController.set('model.selectedFilter', model)

Radium.AddressbookAssignedRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  model: (params) ->
    Radium.User.find params.user_id

  setupController: (controller, model) ->
    addressbookController = @controllerFor('addressbook')
    Ember.run.next =>
      addressbookController.set 'model.assignedUser', model
      addressbookController.set('model.selectedFilter', 'usersContacts')

Radium.AddressbookMemberBaseRoute = Radium.Route.extend Radium.BulkActionEmailEventsMixin,
  setupController: (controller, model) ->
    addressbookController = @controllerFor('addressbook')
    addressbookController.set 'searchText', ''
    addressbookController.set('currentPage', 1)
    Ember.run =>
      addressbookController.set('model.selectedResource', model)
      addressbookController.trigger 'selectedResourceChanged', model
      addressbookController.set 'model.selectedFilter', 'resource'

Radium.AddressbookMembersRoute = Radium.AddressbookMemberBaseRoute.extend
  model: (params) ->
    Radium.Tag.find(params.tag_id)

Radium.AddressbookEmployeesRoute = Radium.AddressbookMemberBaseRoute.extend
  model: (params) ->
    Radium.Company.find(params.company_id)

Radium.AddressbookContactimportjobsRoute = Radium.Route.extend
  model: (params) ->
    Radium.ContactImportJob.find(params.contact_import_job_id)

  setupController: (controller, model) ->
    addressbookController = @controllerFor('addressbook')
    addressbookController.set 'searchText', ''
    addressbookController.set('currentPage', 1)
    Ember.run =>
      addressbookController.set('model.selectedResource', model)
      addressbookController.trigger 'selectedResourceChanged', model
      addressbookController.set 'model.selectedFilter', 'resource'
