Radium.MeetingItem = Em.ObjectProxy.extend
  selectedUser: null
  startTime: null

  hasConflict: ( ->
    @get('startTime').isBetweenExact @get('startsAt').advance(minute: -5), @get('endsAt').advance(minute: -5)
  ).property('startTime', 'startsAt', 'endsAt')

  timeSpan: ( ->
    "#{@get('startsAt').toMeridianTime()} to #{@get('endsAt').toMeridianTime()}"
  ).property('startsAt', 'endsAt')

  topic: ( ->
    @get('content.topic')
  ).property('topic')

  meetingUsers: ( ->
    @get('users').filter (user) => user != @get('selectedUser')
  ).property('users', 'selectedUser')
