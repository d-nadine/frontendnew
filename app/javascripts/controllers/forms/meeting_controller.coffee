Radium.FormsMeetingController = Ember.ObjectController.extend Radium.FormsControllerMixin,
  meetingUsers: null
  calendarsOpen: false
  init: ->
    @_super.apply this, arguments
    # @set 'meetingUsers', Radium.MeetingUsers.create()
    # @set 'meetingUsers.startsAt', @get('startsAt')

  submit: ->
    @set 'isSubmitted', true

  startsAtDidChange: ( ->
    @set('users.startsAt', @get('startsAt')) if @get('startsAt')
  ).observes('startsAt')

  contentDidChange: (->
    return unless @get('model.users.length')

    @get('model.users').forEach (user) =>
      @addUserToMeeting user.get('id')
  ).observes('content')

  usersDidChange: ( ->
    return unless @get('users.length') && @get('startsAt')
    return if @get('calendarsOpen')

    self = this

    @get('users').forEach (user) =>
      meetings = Radium.Meeting.find(user: user, day: @get('startsAt'))
                              .filter (meeting) ->
                                return false if meeting.get('isNew')
                                meeting.get('users').contains(user)

      meetings.forEach (meeting) ->
        startsAt = meeting.get('startsAt').advance(minute: -5)
        endsAt = meeting.get('endsAt').advance(minute: 5)

        if self.get('startsAt').isBetweenExact startsAt, endsAt
          self.set 'calendarsOpen', true

  ).observes('users', 'users.length', 'startsAt')

  showCalendars: ->
    @toggleProperty 'calendarsOpen'
    false

  addUserToMeeting: (userId) ->
    users = @get('users')

    return if users.find( (user) -> user.get('id') == userId )

    user = Radium.User.find(userId)

    users.pushObject user

  removeUserFromMeeting: (userId) ->
    users = @get('users')

    user =  users.find( (user) -> user.get('id') == userId )

    return unless user

    users.removeObject user

  currentDate: ( ->
    @get('startsAt').toHumanFormat()
  ).property('startsAt')
