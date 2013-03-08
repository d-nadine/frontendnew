Radium.MeetingUsers = Ember.ArrayProxy.extend
  init: ->
    @_super.apply this, arguments
    @set 'content', Ember.A()
    @set 'meetings', Ember.A()
    @set 'startsAt', null

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

    @_super.apply this, arguments

  findMeetingsForUser: (user) ->
    return unless @get('startsAt')

    meetings = Radium.Meeting.find(user: user, day: @get('startsAt', exclude: @get('meetingId')))
                              .filter (meeting) ->
                                meeting.get('users').contains(user)

    self = this

    meetings.forEach (meeting) ->
      meeting.get('users').forEach (user) ->
        if self.contains(user)
          existingEntry = self.get('meetings').find (existing) ->
            existing.get('content') == meeting && existing.get('selectedUser') == user

          unless existingEntry
            meetingItem = Radium.MeetingItem.create
              content: meeting
              selectedUser: user
              startTime: self.get('startsAt')

            self.get('meetings').pushObject(meetingItem)

  removeMeetingsForUser: (user) ->
    meetings = @get('meetings')

    meetings.forEach (meeting) ->
      meetings.removeObject(meeting) if meeting.get('users').contains(user)
