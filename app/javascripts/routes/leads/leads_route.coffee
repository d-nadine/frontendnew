Radium.LeadsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    addressbookController = controller.get('addressbook')

    addressbookController.send 'updateTotals'

    currentUser = controller.get('currentUser')

    return if currentUser.get('initialContactsImported')

    poller = Radium.AddressbookTotalsPoller.create(currentUser: currentUser, controller: controller)

    poller.set 'currentUser', currentUser
    poller.start()
    @controllerFor('leadsNew').set 'totalsPoller', poller

  deactivate: ->
    @_super.apply this, arguments
    return unless @controller.get('totalsPoller')

    @controller.get('totalsPoller').stop()
    @controller.set('totalsPoller', null)
