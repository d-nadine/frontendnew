Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  selectedContact: null
  assignedTo: null
  isNewLead: false
  modelBinding: 'contactForm'
  showDetail: false

  init: ->
    @_super.apply this, arguments
    @set 'assignedTo', @get('currentUser')
    # FIXME: development hack
    @set 'isNewLead', true

  toggleDetail: ->
    @toggleProperty 'showDetail'

  leadStatuses: [
    {name: "None", value: "none"}
    {name: "Lead", value: "lead"}
    {name: "Existing Customer", value: "existing"}
    {name: "Exclude From Pipeline", value: "exclude"}
  ]

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

  ).property('isNewLead')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    @set 'justAdded', true

    Ember.run.later( ( =>
      @set 'justAdded', false
      @set 'isSubmitted', false

      # FIXME: Highly controversial but it gets round the form objects
      # not being initialised like a controller.  We need to review this.
      @get('model').commit (contact) =>
        @transitionTo 'contact', contact
    ), 1200)
