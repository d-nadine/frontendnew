require 'lib/radium/aggregate_array_proxy' 

Radium.Meeting = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  organizer: DS.belongsTo('Radium.User')
  invitations: DS.hasMany('Radium.Invitation')

  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')

  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceContact', '_referenceTodo') || @get('_referenceDeal') || @get('_referenceEmail')
  ).property('todo', 'deal', 'email')
  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceTodo: DS.belongsTo('Radium.Todo')

  time: Ember.computed.alias('startsAt')

  participants: Radium.computed.aggregate('users', 'contacts')

  contacts: ( ->
    @get('invitations')
      .filter((invitation) -> invitation?.get('person')?.constructor is Radium.Contact)
      .map((invitation) -> invitation.get('person'))
  ).property('invitations.[]')

  users: ( ->
    @get('invitations')
      .filter((invitation) -> invitation.get('person')?.constructor is Radium.User)
      .map((invitation) -> invitation.get('person'))
  ).property('invitations.[]')
