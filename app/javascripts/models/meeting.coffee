require 'lib/radium/aggregate_array_proxy'

Radium.Meeting = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  invitations: DS.hasMany('Radium.Invitation')

  topic: DS.attr('string')
  description: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')

  displayName: Ember.computed.alias 'topic'

  # Client side only, so user can choose to decline a meeting.
  cancelled: DS.attr('boolean')

  organizer: Ember.computed '_organizerUser', '_organizerContact', ->
    @get('_organizerUser') ||
    @get('_organizerContact')

  _organizerUser: DS.belongsTo('Radium.User')
  _organizerContact: DS.belongsTo('Radium.Contact')

  reference: Ember.computed 'todo', 'deal', 'email', (key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceContact', '_referenceTodo') || @get('_referenceDeal') || @get('_referenceEmail')

  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceTodo: DS.belongsTo('Radium.Todo')

  activities: DS.hasMany('Radium.Activity', inverse: '_referenceMeeting')

  todos: DS.hasMany('Radium.Todo')
  notes: DS.hasMany('Radium.Note', inverse: '_referenceMeeting')

  tasks: Radium.computed.tasks('todos')

  time: Ember.computed.alias('startsAt')

  contacts: Ember.computed 'invitations.[]', 'invitations.@each.person', ->
    return Ember.A() unless @get('invitations.length')

    contacts = @get('invitations')
      .filter((invitation) -> invitation?.get('person')?.constructor is Radium.Contact)
      .map((invitation) -> invitation.get('person'))

    contacts

  users: Ember.computed 'invitations.[]', ->
    return Ember.A() unless @get('invitations.length')

    @get('invitations')
      .filter((invitation) -> invitation.get('person')?.constructor is Radium.User)
      .map((invitation) -> invitation.get('person'))

  isFinished: Ember.computed 'startsAt', ->
    return unless @get('startsAt')

    @get('startsAt').isBeforeNow()

  clearRelationships: ->
    @get('activities').compact().forEach (activity) ->
      activity.unloadRecord()

    @get('tasks').compact().forEach (task) ->
      task.unloadRecord()

    Radium.Notification.all().compact().forEach (notification) ->
      if notification.get('_referenceMeeting') == this
        notification.deleteRecord()
