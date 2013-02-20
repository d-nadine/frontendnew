Radium.MeetingUsers = Ember.ArrayProxy.extend
  content: []
  meetings: []
  startsAt: null

  startsAtDidChange: ( ->
    return unless @get('startsAt') && @get('content.length')
    @get('meetings').clear()

    @forEach (user) =>
      @findMeetingsForUser(user)
  ).observes('startsAt')

  arrayContentDidChange: (startIdx, removeAmt, addAmt) ->
    @_super.apply this, arguments

    if addAmt > 0
      @findMeetingsForUser @objectAt(startIdx)

  arrayContentWillChange: (startIdx, removeAmt, addAmt) ->
    if removeAmt > 0
      @removeMeetingsForUser @objectAt(startIdx)

  findMeetingsForUser: (user) ->
    return unless @get('startsAt')

    meetings = Radium.Meeting.find(user: user, day: @get('startsAt'))
                              .filter (meeting) ->
                                return false if meeting.get('isNew') || !meeting.get('users.length')
                                meeting.get('users').contains(user)

    meetings.forEach (meeting) =>
      @get('meetings').pushObject(meeting) unless @get('meetings').contains(meeting)

  removeMeetingsForUser: (user) ->
    meetings = @get('meetings')

    meetings.forEach (meeting) ->
      meetings.removeObject(meeting) if meeting.get('users').contains(user)
