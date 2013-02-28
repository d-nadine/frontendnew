Radium.FormsMeetingController = Ember.ObjectController.extend Radium.FormsControllerMixin,
  needs: ['groups']
  groups: Ember.computed.alias('controllers.groups')
  source: Ember.computed.alias 'attendees'
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

  attendees: ( ->
    Radium.PeopleList.listPeople(@get('users'), @get('contacts'))
  ).property('users', 'contacts', 'users.length', 'contacts.length')

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

  submit: ->
    @set 'isSubmitted', true

    unless @get('isNew')
      @get('content.transaction').commit()
      return

    meeting = Radium.Meeting.createRecord
      topic: @get('topic')
      location: @get('location')
      startsAt: @get('startAt')
      endsAt: @get('endsAt')
      user: @get('currentUser')

    @get('users').forEach (user) ->
      meeting.get('users').addObject user

    @get('contacts').forEach (contact) ->
      meeting.get('contacts').addObject contact

    meeting.get('transaction').commit()

  startsAtDidChange: ( ->
    startsAt = @get('startsAt')
    endsAt = @get('endsAt')

    return unless startsAt

    @set('meetingUsers.startsAt', startsAt)

    return unless Ember.DateTime.compare(endsAt, startsAt) == -1

    @set('endsAt', startsAt.advance(hour: 1))

    console.log @get('endsAt').toMeridianTime()
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

  addSelection: (attendee) ->
    resource = if attendee.constructor == Radium.User then 'users' else 'contacts'

    attendees = @get(resource)

    return if attendees.find( (item) -> item == attendee)

    attendees.pushObject attendee

    @get('meetingUsers').pushObject attendee if attendee.constructor == Radium.User

  removeUserFromMeeting: (user) ->
    users = @get('users')

    users.removeObject user

    @get('meetingUsers').removeObject user

  currentDate: ( ->
    @get('startsAt').toHumanFormat()
  ).property('startsAt')
