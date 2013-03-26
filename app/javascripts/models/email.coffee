Radium.Email = DS.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  todos: DS.hasMany('Radium.Todo')
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

  tasks: Radium.computed.tasks('todos', 'meetings')

  people: Radium.computed.aggregate('to','cc')

  contact: (->
    if @get('sender') instanceof Radium.Contact
      @get('sender')
    else
      @get('people').find (person) -> person instanceof Radium.Contact
  ).property()
