Radium.LeadsSingleRoute = Ember.Route.extend
  model: ->
    @get('contactForm')

  contactForm:  Radium.computed.newForm('contact')

  contactFormDefaults: Ember.computed ->
    isNew: true
    isSubmitted: false
    isSaving: false
