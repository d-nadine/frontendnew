Radium.MeetingItem = Em.ObjectProxy.extend
  selectedUser: null
  startsAt: null
  endsAt: null

  hasConflict: ( ->
    false
  ).property('startsAt', 'endsAt')

  timeSpan: ( ->
    "#{@get('startsAt').toMeridianTime()} to #{@get('endsAt').toMeridianTime()}"
  ).property('startsAt', 'endsAt')

  topic: ( ->
    @get('content.topic')
  ).property('topic')

  meetingUsers: ( ->
    @get('users').filter (user) => user != @get('selectedUser')
  ).property('users', 'selectedUser')
