Radium.MeetingUsers = Ember.ArrayProxy.extend
  init: ->
    @_super.apply this, arguments
    @set 'content', Ember.A()
    @set 'meetings', Ember.A()
    @set 'startsAt', null
    @get('content').addArrayObserver(this)

  startsAtDidChange: ( ->
    return unless @get('startsAt') && @get('content.length')
    @get('meetings').clear()

    @get('content').forEach (user) =>
      @findMeetingsForUser(user)
  ).observes('startsAt')

  arrayDidChange: (content, idx, removedCnt, addedCnt) ->
    if addedCnt > 0
      @findMeetingsForUser content[idx]

  arrayWillChange: (content, idx, removedCnt, addedCnt) ->
    if removedCnt > 0
      @removeMeetingsForUser content[idx]

  activeMeetings: Ember.computed 'meetings.[]', 'meetings.@each.isDeleted', ->
    @get('meetings').reject (meeting) => meeting.get('isDeleted') || meeting.get('isFinished')

  findMeetingsForUser: (user) ->
    return unless @get('startsAt')

    startsAt = @get('startsAt')
    start = startsAt.atBeginningOfDay().toFullFormat()
    end = startsAt.atEndOfDay().toFullFormat()

    params = user_id: user.get('id'), start_date: start, end_date: end

    if meetingId = @get('meetingId')
      params['exclude_ids'] = meetingId

    Radium.Meeting.find(params).then (meetings) =>
      meetings.forEach (meeting) =>
        existingEntry = @get('meetings').find (existing) ->
          existing.get('content') == meeting && existing.get('selectedUser') == user

        unless existingEntry
          meetingItem = Radium.MeetingItem.create
            content: meeting
            selectedUser: user
            startTime: @get('startsAt')

          @get('meetings').pushObject(meetingItem)

          if meetingItem.get('hasConflict')
            @set 'parent.calendarsOpen', true

  removeMeetingsForUser: (user) ->
    meetings = @get('meetings')

    meetings.forEach (meeting) ->
      meetings.removeObject(meeting) if meeting.get('selectedUser') == user
