Radium.MessagesSidebarItemController = Radium.ObjectController.extend
  needs: ['messages', 'emailsThread']
  selectedContent: Ember.computed.oneWay('controllers.messages.selectedContent')
  isSelectable: Ember.computed.oneWay('controllers.messages.canSelectItems')

  folder: Ember.computed.oneWay 'controllers.messages.folder'

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

  showSubject: Ember.computed 'folder', 'model.subject', ->
    return false unless folder = @get('folder')

    ['inbox', 'drafts', 'archive', 'sent', 'scheduled'].contains folder
