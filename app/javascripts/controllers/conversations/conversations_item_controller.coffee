Radium.ConversationsItemController = Radium.ObjectController.extend
  conversationType: Ember.computed.oneWay 'parentController.conversationType'
  incoming: Ember.computed.equal 'conversationType', 'incoming'
  isIgnored: Ember.computed.oneWay 'parentController.isIgnored'

  contact: Ember.computed 'sender', 'conversationType', 'toList.[]', ->
    if @get('sender').constructor is Radium.Contact
      return @get('sender')

    return unless @get('toList.length')

    contact = @get('toList').find (r) -> r.constructor is Radium.Contact

    return unless contact

    return contact if contact.get('isLoaded')

    self = this

    observer = ->
      return unless contact.get('isLoaded')

      contact.removeObserver "isLoaded", observer

      self.set 'contact', contact

    contact.addObserver 'isLoaded', observer

  assignedTo: Ember.computed 'contact', 'contact.user', ->
    @get('contact.user')

  assignees: Ember.computed 'parentController.users.[]', 'assignedTo', ->
    @get('parentController.users').reject (user) =>
      user == @get('assignedTo')