require 'lib/radium/aggregate_array_proxy'

Radium.Meeting = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  user: DS.belongsTo('Radium.User')
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')

  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')

  user: DS.belongsTo('Radium.User')
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')

  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

  deal: DS.belongsTo('Radium.Deal')
  email: DS.belongsTo('Radium.Email')
  todo: DS.belongsTo('Radium.Todo')

  todos: DS.hasMany('Radium.Todo')

  tasks: Radium.computed.tasks('todos', 'meetings')


  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('todo') || @get('deal') || @get('email')
  ).property('todo', 'deal', 'email')

  time: Ember.computed.alias('startsAt')

  people: Radium.computed.aggregate('users', 'contacts')
