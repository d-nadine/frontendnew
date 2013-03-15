Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  selectedContact: null
  assignedTo: null
  isNewLead: false
  modelBinding: 'contactForm'

  leadStatus: [
    {name: "None", value: "none"}
    {name: "lead", value: "lead"}
    {name: "Existing Customer", value: "existing"}
    {name: "Exclude From Pipeline", value: "exclude"}
  ]

  init: ->
    @_super.apply this, arguments
    @set 'assignedTo', @get('currentUser')
    # FIXME: development hack
    @set 'isNewLead', true

  contactForm:  Radium.computed.newForm('contact')

  contactFormDefaults: ( ->
    name: null
    type: 'lead'
    status: 'lead'
    phoneNumbers: [
      Ember.Object.create({name: 'Mobile', value: null, isPrimary: true}),
      Ember.Object.create({name: 'Work', value: null}),
      Ember.Object.create({name: 'Home', value: null})
    ]
    emailAddresses: [
      Ember.Object.create({name: 'Work', value: null, isPrimary: true}),
      Ember.Object.create({name: 'Home', value: null}),
    ]
  ).property('isNewLead')
