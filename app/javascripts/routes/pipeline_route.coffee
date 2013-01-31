Radium.PipelineRoute = Ember.Route.extend
  setupController: ->
    # FIXME: Replace with real query
    contacts = Radium.Contact.all()
    deals = Radium.Deal.all()
    @controllerFor('pipelineStatus').set('contacts', contacts)
    @controllerFor('pipelineStatus').set('deals', deals)
