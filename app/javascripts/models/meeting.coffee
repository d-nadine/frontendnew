require 'lib/radium/aggregate_array_proxy'

Radium.Meeting = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  user: DS.belongsTo('Radium.User')
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')

  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')

  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('_referenceTodo') || @get('_referenceDeal') || @get('_referenceEmail')
  ).property('todo', 'deal', 'email')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceTodo: DS.belongsTo('Radium.Todo')

  time: Ember.computed.alias('startsAt')

  participants: Radium.computed.aggregate('users', 'contacts')
