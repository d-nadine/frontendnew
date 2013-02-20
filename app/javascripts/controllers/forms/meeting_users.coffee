Radium.MeetingUsers = Ember.ArrayProxy.extend
  content: []
  meetings: []
  startsAt: null

  startsAtDidChange: ( ->
    return unless @get('startsAt') && @get('content.length')
    console.log @get('startsAt')
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

    meetings = Radium.Meeting.find user: user, day: @get('startsAt')

    @get('meetings').pushObjects(meetings.toArray()) if meetings.get('length')

  removeMeetingsForUser: (user) ->
    meetings = @get('meetings').filterProperty 'user', user

    @get('meetings').removeObjects meetings if meetings.get('length')
