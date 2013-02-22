Radium.FormsMeetingController = Ember.ObjectController.extend Radium.FormsControllerMixin,
  meetingUsers: null
  calendarsOpen: null
  init: ->
    @_super.apply this, arguments
    @set 'meetingUsers', Radium.MeetingUsers.create()
    @set 'meetingUsers.meetingId', this.get('id')
    @set 'calendarsOpen', false

  hasElapsed: ( ->
    return unless @get('startsAt')

    @get('startsAt').isBeforeToday()
  ).property('startsAt')

  submit: ->
    @set 'isSubmitted', true

  startsAtDidChange: ( ->
    @set('meetingUsers.startsAt', @get('startsAt')) if @get('startsAt')
  ).observes('startsAt')

  usersDidChange: ( ->
    return if @get('calendarsOpen')
    return unless @get('users.length') && @get('startsAt')

    self = this

    @get('users').forEach (user) =>
      meetings = Radium.Meeting.find(user: user, day: @get('startsAt'), meetingId: self.get('id'))
                              .filter (meeting) ->
                                return false if meeting.get('isNew')
                                meeting.get('users').contains(user)

      meetings.forEach (meeting) ->
        startsAt = meeting.get('startsAt').advance(minute: -5)
        endsAt = meeting.get('endsAt').advance(minute: 5)

        if self.get('startsAt').isBetweenExact startsAt, endsAt
          self.set 'calendarsOpen', true

  ).observes('users', 'users.length', 'startsAt')

  isExpandable: (->
    return false if @get('justAdded')
    !@get('isNew')
  ).property('isNew')

  showCalendars: ->
    @toggleProperty 'calendarsOpen'
    false

  addUserToMeeting: (userId) ->
    users = @get('users')

    return if users.find( (user) -> user.get('id') == userId )

    user = Radium.User.find(userId)

    users.pushObject user
    @get('meetingUsers').pushObject user

  removeUserFromMeeting: (userId) ->
    users = @get('users')

    user =  users.find( (user) -> user.get('id') == userId )

    return unless user

    users.removeObject user
    @get('meetingUsers').removeObject user

  currentDate: ( ->
    @get('startsAt').toHumanFormat()
  ).property('startsAt')
