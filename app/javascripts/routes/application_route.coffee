Radium.ApplicationRoute = Radium.Route.extend
  events:
    toggleDrawer: (name) ->
      if @get('router.openDrawer') == name
        @send 'closeDrawer'
      else
        route = name.split('/')[0]

        Ember.assert("Could not find a matching controller for: #{name}", route)

        @render name,
          outlet: 'drawer'
          into: 'application'
          controller: @controllerFor(route)

        @set 'router.openDrawer', name

    closeDrawer: ->
      @render 'nothing',
        into: 'application'
        outlet: 'drawer'

      @set 'router.openDrawer', null

    closeModal: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    back: ->
      history = @get('router.history')

      if history.length > 2
        history.pop()
        lastPage = history.pop()
      else if history.length == 2
        lastPage = history.shift()
        history.clear()
      else
        return

      if lastPage[1]
        @transitionTo lastPage[0], lastPage[1]
      else
        @transitionTo lastPage[0]

    createDealFromContact: (contact) ->
      controller = @controllerFor('deals.new')
      controller.set('model.contact', contact)
      controller.set('model.source', 'Lead Form')
      @transitionTo 'deals.new'

  setupController: ->
    @controllerFor('currentUser').set 'model', Radium.User.find(1)
    @controllerFor('users').set 'model', Radium.User.find()
    @controllerFor('contacts').set 'model', Radium.Contact.find()
    @controllerFor('groups').set 'model', Radium.Group.find()

    @controllerFor('clock').set 'model', Ember.DateTime.create()

    settings = Radium.Settings.find(1)
    @controllerFor('settings').set 'model', settings

    dealForm = @get('dealForm')

    dealForm.get('checklist.checklistItems').pushObjects settings.get('checklist.checklistItems').map (checkListItem) ->
                                                                          Ember.Object.create(checkListItem.serialize())
    dealForm.set 'user', @controllerFor('currentUser').get('model')

    dealForm.set 'additionalChecklistItem', Ember.Object.create
                                                description: ''
                                                weight: 0

    @controllerFor('deals.new').set 'model', dealForm

  renderTemplate: ->
    @render()

    @render 'drawer_panel',
      into: 'application'
      outlet: 'drawerPanel'

  dealForm:  Radium.computed.newForm('deal')

  dealFormDefaults: ( ->
    name: ''
    user: null
    contact: null
    todo: null
    email: null
    source: ''
    status: null
    value: 0
    checklist:
      checklistItems: []
    poNumber: ''
  ).property()
