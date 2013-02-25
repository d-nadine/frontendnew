Radium.FormsMeetingController = Ember.ObjectController.extend Radium.FormsControllerMixin,
  meetingUsers: null
  calendarsOpen: null
  init: ->
    @_super.apply this, arguments
    @set 'meetingUsers', Radium.MeetingUsers.create()
    @set 'meetingUsers.meetingId', this.get('id')
    @set 'calendarsOpen', false

  isEditable:( ->
    return false if @get('isNew')
    return false unless @get('content.isEditable')
    return false if @get('justAdded')
    return false if @get('hasElapsed')
    true
  ).property('isNew', 'justAdded', 'hasElapsed', 'content.isEditable')

  showTopicTextBox: ( ->
    return true if @get('isNew')
    return false if @get('notEditable')
    return true if @get('isNew')
    @get('isExpanded')
  ).property('isNew', 'notEditable', 'isExpanded')

  notEditable: ( ->
    not @get('isEditable')
  ).property('isEditable')

  hasElapsed: ( ->
    return unless @get('startsAt')

    @get('startsAt').isBeforeToday()
  ).property('startsAt')

  showComments: (->
    return false if @get('justAdded')
    return false if @get('isNew')
    true
  ).property('isNew', 'justAdded')

  cancellationText: ( ->
    topic = @get('content.content.topic')

    users = @get('users').map( (user) -> "@#{user.get('name')}").join(', ')

    "#{topic} with #{users} at #{@get('startsAt').toHumanFormatWithTime()}"
  ).property('topic', 'isNew')

  readableStartsAt: ( ->
    @get('startsAt').toHumanFormatWithTime()
  ).property('startsAt')

  submit: ->
    @set 'isSubmitted', true

  startsAtDidChange: ( ->
    @set('meetingUsers.startsAt', @get('startsAt')) if @get('startsAt')
  ).observes('startsAt')

  # FIXME: Review when using real ember-data
  usersDidChange: ( ->
    return if @get('calendarsOpen')
    return unless @get('isExpanded')
    return unless @get('users.length') && @get('startsAt')

    self = this

    @get('users').forEach (user) =>
      if user
        meetings = Radium.Meeting.find(user: user, day: @get('startsAt'), meetingId: self.get('id'))
                                .filter (meeting) ->
                                  return false if meeting.get('isNew')
                                  meeting.get('users').contains(user)

        meetings.forEach (meeting) ->
          startsAt = meeting.get('startsAt').copy().advance(minute: -5)
          endsAt = meeting.get('endsAt').copy().advance(minute: 5)

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

  addUserToMeeting: (user) ->
    users = @get('users')

    return if users.find( (item) -> item == user)

    users.pushObject user

    @get('meetingUsers').pushObject user

  removeUserFromMeeting: (user) ->
    users = @get('users')

    users.removeObject user

    @get('meetingUsers').removeObject user

  currentDate: ( ->
    @get('startsAt').toHumanFormat()
  ).property('startsAt')
