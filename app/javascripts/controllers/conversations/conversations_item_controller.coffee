Radium.ConversationsItemController = Radium.ObjectController.extend
  conversationType: Ember.computed.oneWay 'parentController.conversationType'
  incoming: Ember.computed.equal 'conversationType', 'incoming'
  truncatedSubject: Ember.computed 'subject', ->
    max = 25
    subject = @get('subject')
    if subject.length < max
      subject
    else
      "#{subject.substring(0, max)}..."

  contact: Ember.computed 'sender', 'conversationType', ->
    if @get('incoming')
      @get('sender')

  assignedTo: Ember.computed 'contact', 'contact.user', ->
    @get('contact.user')

  assignees: Ember.computed 'parentController.users.[]', 'assignedTo', ->
    @get('parentController.users').reject (user) => user == @get('assignedTo')