require 'forms/form'

Radium.MeetingForm = Radium.Form.extend
  data: ( ->
    topic: @get('topic')
    location: @get('location')
    startsAt: @get('startsAt')
    endsAt: @get('endsAt')
    user: @get('user')
  ).property().volatile()

  startsAtIsInvalid: ( ->
    now = Ember.DateTime.create().advance(minute: -5)
    Ember.DateTime.compare(@get('startsAt'), now)  == -1
  ).property('startsAt')

  endsAtIsInvalid: ( ->
    Ember.DateTime.compare(@get('endsAt'), @get('startsAt')) == -1
  ).property('startsAt', 'endsAt')

  reset: ->
    @_super.apply this, arguments
    @get('users').clear()
    @get('contacts').clear()
    @get('users').addObject(@get('user')) if @get('user')


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
                Radium.Meeting.createRecord @get('data')
              else
                @get('model')

    @get('users').forEach (user) ->
      meeting.get('users').addObject user unless meeting.get('users').contains user

    @get('contacts').forEach (contact) ->
      meeting.get('contacts').addObject contact unless meeting.get('contacts').contains contact

    @get('store').commit()
