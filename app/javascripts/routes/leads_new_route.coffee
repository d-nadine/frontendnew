Radium.LeadsNewRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'model', @get 'contactForm'
    controller.set 'model.assignedTo', @controllerFor('currentUser').get('model')

  contactForm:  Radium.computed.newForm('contact')

  addressDefaults: ->
    street: ''
    city: ''
    state: ''
    zipcode: ''
    country: ''

  contactFormDefaults: ( ->
    isNew: true
    name: ''
    status: 'lead'
    notes: null
    source: ''
    assignedTo: null
    phoneNumbers: [
      Ember.Object.create({name: 'Mobile', value: '', isPrimary: true}),
      Ember.Object.create({name: 'Work', value: ''}),
      Ember.Object.create({name: 'Home', value: ''})
    ]
    emailAddresses: [
      Ember.Object.create({name: 'Work', value: '', isPrimary: true}),
      Ember.Object.create({name: 'Home', value: ''}),
    ]
    addresses: [
      Ember.Object.create({name: 'Office', value: Ember.Object.create(@addressDefaults()), isPrimary: true}),
      Ember.Object.create({name: 'Home', value:  Ember.Object.create(@addressDefaults())}),
    ]
  ).property()
