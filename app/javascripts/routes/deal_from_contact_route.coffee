Radium.DealsFromContactRoute = Radium.Route.extend
  setupController: (controller, model) ->
    dealsController = @controllerFor 'dealsNew'
    dealsController.set 'model', @get 'dealForm'
    dealsController.get('model').reset()
    dealsController.set 'user', @controllerFor('currentUser').get('model')
    dealsController.get('model.forecast').pushObjects @controllerFor('accountSettings').get('dealChecklist').map (checkListItem) ->
                                                                          Ember.Object.create(checkListItem)
    dealsController.set 'contact', model
    dealsController.set 'status', @controllerFor('accountSettings').get('dealStates.firstObject')

  renderTemplate: ->
    @render 'deals.new',
      controller: 'dealsNew'

  dealForm:  Radium.computed.newForm('deal')

  dealFormDefaults: ( ->
    isNew: true
    contact: null
    description: ''
    todo: null
    email: null
    forecast: Ember.A()
  ).property()
