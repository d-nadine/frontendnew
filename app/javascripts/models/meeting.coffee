require 'lib/radium/aggregate_array_proxy' 

Radium.Meeting = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  invitations: DS.hasMany('Radium.Invitation')

  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')

  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

  organizer: ( ->
    @get('_organizerUser') ||
    @get('_organizerContact')
  ).property('_organizerUser', '_organizerContact')
  _organizerUser: DS.belongsTo('Radium.User')
  _organizerContact: DS.belongsTo('Radium.Contact')

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

  activities: DS.hasMany('Radium.Activity', inverse: '_referenceMeeting')

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')

  tasks: Radium.computed.tasks('todos', 'calls')

  time: Ember.computed.alias('startsAt')

  contacts: ( ->
    return Ember.A() unless @get('invitations.length')

    @get('invitations')
      .filter((invitation) -> invitation?.get('person')?.constructor is Radium.Contact)
      .map((invitation) -> invitation.get('person'))
  ).property('invitations.[]')

  users: ( ->
    return Ember.A() unless @get('invitations.length')

    @get('invitations')
      .filter((invitation) -> invitation.get('person')?.constructor is Radium.User)
      .map((invitation) -> invitation.get('person'))
  ).property('invitations.[]')

  attachedFiles: DS.attr('array')

  clearRelationships: ->
    @get('activities').compact().forEach (activity) =>
      activity.deleteRecord()

    @get('tasks').compact().forEach (task) =>
      task.deleteRecord()

    Radium.Notification.all().compact().forEach (notification) =>
      if notification.get('_referenceMeeting') == this
        notification.deleteRecord()
