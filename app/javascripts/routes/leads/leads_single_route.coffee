Radium.LeadsSingleRoute = Ember.Route.extend
  actions:
    modelChanged: (model) ->
      controller = @controller
      controller.set 'form', null
      controller.set 'model', model

  model: ->
    @get('contactForm')

  contactForm:  Radium.computed.newForm('contact')

  contactFormDefaults: Ember.computed ->
    isNew: true
    isSubmitted: false
    isSaving: false
