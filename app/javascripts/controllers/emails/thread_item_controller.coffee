Radium.EmailThreadItemController = Radium.ObjectController.extend Ember.Evented,
  needs: ['messages', 'emailsThread']
  selectedEmail: Ember.computed.oneWay 'controllers.messages.selectedContent'
  folder: Ember.computed.oneWay 'controllers.messages.folder'
  isSelected: Ember.computed 'model', 'selectedEmail', ->
    @get('model') == @get('selectedEmail')
