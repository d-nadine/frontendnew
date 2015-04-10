Radium.MessagesSidebarItemController = Radium.ObjectController.extend Radium.EmailDealMixin,
  needs: ['messages', 'emailsThread']
  selectedContent: Ember.computed.alias('controllers.messages.selectedContent')
  isSelectable: Ember.computed.alias('controllers.messages.canSelectItems')

  isSelected: Ember.computed 'selectedContent', ->
    @get('model') == @get('selectedContent')

  timestamp: Ember.computed ->
    @get('sentAt') || @get('createdAt')

  fromUser: Ember.computed 'sender', ->
    unless sender = @get('sender')
      return

    sender.constructor is Radium.User && sender != @get('currentUser')

  hasLead: Ember.computed 'sender', 'sender.isLoaded', ->
    unless sender = @get('sender')
      return

    sender.get('isPublic')

  canArchive: Ember.computed 'controllers.messages.folder', ->
    @get('controllers.messages.folder') != 'archive'

  threadIsLoading: Ember.computed.bool 'model.isTransitioning'
