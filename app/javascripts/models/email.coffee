Radium.Email = DS.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')

  subject: DS.attr('string')
  message: DS.attr('string')
  read: DS.attr('boolean')
  isTracked: DS.attr('boolean')
  sentAt: DS.attr('datetime')

  sender: DS.attr('object')

  # FIXME: find a better way to handle this
  # once we get the API connntected
  to: DS.attr('array')
  cc: DS.attr('array')
  bcc: DS.attr('array')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  people: Radium.computed.aggregate('to','cc')

  contact: (->
    if @get('sender') instanceof Radium.Contact
      @get('sender')
    else
      @get('people').find (person) -> person instanceof Radium.Contact
  ).property()

  # FIXME: determine how this should work?
  isIncludedInConversation: (email) ->
    sender = @get 'sender'

    return true if email.get('sender') is sender
    return true if email.get('to').indexOf(sender) != -1
    false


