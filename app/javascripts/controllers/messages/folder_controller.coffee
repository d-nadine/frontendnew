Radium.MessagesFolderController = Radium.ObjectController.extend
  needs: ['messages']
  isSelected: Ember.computed 'controllers.messages.folder', ->
    @get('controllers.messages.folder') == @get('name')
