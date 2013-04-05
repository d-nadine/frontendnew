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
      controller.get('model').reset()
      controller.set 'user', @controllerFor('currentUser').get('model')
      controller.set('contact', contact)
      controller.set('source', Ember.Object.create(name: 'Lead Form'))
      @transitionTo 'deals.new'

  setupController: ->
    @controllerFor('currentUser').set 'model', Radium.User.find(1)
    @controllerFor('users').set 'model', Radium.User.find()
    @controllerFor('contacts').set 'model', Radium.Contact.find()
    @controllerFor('groups').set 'model', Radium.Group.find()
    @controllerFor('companies').set 'model', Radium.Company.find()

    @controllerFor('clock').set 'model', Ember.DateTime.create()

    settings = Radium.Settings.find(1)
    @controllerFor('settings').set 'model', settings

    dealForm = @get('dealForm')
    dealForm.set('checklist', Ember.Object.createWithMixins(Radium.ChecklistTotalMixin))
    dealForm.set('checklist.checklistItems', Ember.A())
    dealForm.get('checklist.checklistItems').pushObjects settings.get('checklist.checklistItems').map (checkListItem) ->
                                                                          Ember.Object.create(checkListItem.serialize())
    dealForm.set 'user', @controllerFor('currentUser').get('model')

    @controllerFor('deals.new').set 'model', dealForm

  renderTemplate: ->
    @render()

    @render 'drawer_panel',
      into: 'application'
      outlet: 'drawerPanel'

  dealForm:  Radium.computed.newForm('deal')

  dealFormDefaults: ( ->
    isNew: true
    company: null
    name: ''
    user: null
    contact: null
    description: ''
    todo: null
    email: null
    source: ''
    status: null
    value: 0
    isPublished: true
    poNumber: ''
  ).property()
