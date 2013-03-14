Radium.LeadsNewController= Ember.ObjectController.extend
  needs: ['contacts']
  contacts: Ember.computed.alias 'controllers.contacts'
