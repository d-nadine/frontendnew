Radium.LeadsNewRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'model', @get 'contactForm'

  contactForm:  Radium.computed.newForm('contact')

  addressDefaults: ->
    street: null
    city: null
    state: null
    zipcode: null
    country: null

  contactFormDefaults: ( ->
    name: ''
    status: 'lead'
    notes: null
    source: ''
    phoneNumbers: [
      Ember.Object.create({name: 'Mobile', value: null, isPrimary: true}),
      Ember.Object.create({name: 'Work', value: null}),
      Ember.Object.create({name: 'Home', value: null})
    ]
    emailAddresses: [
      Ember.Object.create({name: 'Work', value: null, isPrimary: true}),
      Ember.Object.create({name: 'Home', value: null}),
    ]
    addresses: [
      Ember.Object.create({name: 'Office', value: Ember.Object.create(@addressDefaults()), isPrimary: true}),
      Ember.Object.create({name: 'Home', value:  Ember.Object.create(@addressDefaults())}),
    ]

  ).property()
