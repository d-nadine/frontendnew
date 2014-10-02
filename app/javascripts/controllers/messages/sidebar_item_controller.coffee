Radium.MessagesSidebarItemController = Radium.ObjectController.extend Radium.EmailDealMixin,
  needs: ['messages']
  selectedContent: Ember.computed.alias('controllers.messages.selectedContent')
  isSelectable: Ember.computed.alias('controllers.messages.canSelectItems')

  isSelected: Ember.computed 'selectedContent', ->
    @get('content') == @get('selectedContent')

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

  onArchiveTab: Ember.computed.equal 'controllers.messages.folder', 'archive'
