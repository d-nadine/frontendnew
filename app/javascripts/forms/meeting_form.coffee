require 'forms/form'

Radium.MeetingForm = Radium.Form.extend
  data: ( ->
    topic: @get('topic')
    location: @get('location')
    startsAt: @get('startsAt')
    endsAt: @get('endsAt')
    invitations: Ember.A()
  ).property().volatile()

  startsAtIsInvalid: ( ->
    now = Ember.DateTime.create().advance(minute: -5)
    Ember.DateTime.compare(@get('startsAt'), now)  == -1
  ).property('startsAt')

  endsAtIsInvalid: ( ->
    Ember.DateTime.compare(@get('endsAt'), @get('startsAt')) == -1
  ).property('startsAt', 'endsAt')

  reset: ->
    return unless @get('isNew')
    @_super.apply this, arguments
    @get('users').clear()
    @get('contacts').clear()
    @get('invitations').clear()

  isValid: ( ->
    return if Ember.isEmpty(@get('topic'))
    return if @get('startsAtIsInvalid')
    return if @get('startsAt').isBeforeToday()
    return if @get('endsAtIsInvalid')

    true
  ).property('topic', 'startsAt', 'endsAt')

  commit: ->
    isNew = @get('isNew')

    meeting = if isNew
                Radium.CreateMeeting.createRecord @get('data')
              else
                @get('model')

    if isNew
      @get('users').forEach (user) =>
        meeting.get('invitations').addObject person: type: 'user', id: user.get('id')

      @get('contacts').forEach (contact) =>
        if contact.get('id')
          meeting.get('invitations').addObject person: type: 'contact', id: contact.get('id')
        else
          meeting.get('invitations').addObject email: contact.get('email')

      if @get('reference') && @get('reference.constructor') is Radium.Contact
          meeting.get('invitations').addObject person: type: 'contact', id: @get('reference.id')

    @get('store').commit()
