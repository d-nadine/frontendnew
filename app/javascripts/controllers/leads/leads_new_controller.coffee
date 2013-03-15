Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  selectedContact: null
  assignedTo: null
  isNewLead: false
  modelBinding: 'contactForm'

  init: ->
    @_super.apply this, arguments
    @set 'assignedTo', @get('currentUser')
    # FIXME: development hack
    @set 'isNewLead', true

  contactForm:  Radium.computed.newForm('contact')

  contactFormDefaults: ( ->
    name: null
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
