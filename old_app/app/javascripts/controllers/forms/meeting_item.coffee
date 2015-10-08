Radium.MeetingItem = Em.ObjectProxy.extend
  selectedUser: null
  startTime: null

  hasConflict: Ember.computed 'startTime', 'startsAt', 'endsAt', ->
    startsAt = @get('startsAt').advance(minute: -5)
    endsAt = @get('endsAt').advance(minute: 5)

    @get('startTime').isBetween startsAt, endsAt

  topic: Ember.computed 'topic', ->
    @get('content.topic')

  meetingUsers: Ember.computed 'users', 'selectedUser', ->
    @get('users').filter (user) => user != @get('selectedUser')
