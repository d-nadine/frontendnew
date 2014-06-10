Radium.EmailThreadItemController = Radium.ObjectController.extend
  needs: ['messages']
  selectedEmail: Ember.computed.oneWay 'controllers.messages.selectedContent'
  isSelected: Ember.computed 'model', 'selectedEmail', ->
    @get('model') == @get('selectedEmail')
