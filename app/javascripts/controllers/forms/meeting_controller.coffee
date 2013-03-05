Radium.FormsMeetingController = Ember.ObjectController.extend Radium.FormsControllerMixin,
  needs: ['groups','contacts','users']
  groups: Ember.computed.alias('controllers.groups')
  source: Ember.computed.alias 'attendees'
  userList: Ember.computed.alias 'controllers.users'
  contactList: Ember.computed.alias 'controllers.contacts'
  meetingUsers: null
  calendarsOpen: null

  init: ->
    @_super.apply this, arguments
    @set 'meetingUsers', Radium.MeetingUsers.create()
    @set 'meetingUsers.meetingId', this.get('id')
    @set 'calendarsOpen', false

  people: ( ->
    Radium.PeopleList.listPeople(@get('userList').mapProperty('content'), @get('contactList')).filter (person) -> person.get('email')
  ).property('userList', 'userList.length', 'contactList', 'contactList.length')

  isEditable:( ->
    return false if @get('isNew')
    return false unless @get('content.isEditable')
    return false if @get('justAdded')
    return false if @get('hasElapsed')
    true
  ).property('isNew', 'justAdded', 'hasElapsed', 'content.isEditable')

  locations: ( ->
    @get('groups').map (group) -> Ember.Object.create
                                    name: "#{group.get('name')}, #{group.get('address')}"
  ).property()

  attendees: ( ->
    Radium.PeopleList.listPeople(@get('users'), @get('contacts'))
  ).property('users.[]', 'contacts.[]')

  showTopicTextBox: ( ->
    return true if @get('isNew')
    return false if @get('isDisabled')
    return true if @get('isNew')
    @get('isExpanded')
  ).property('isNew', 'isDisabled', 'isExpanded')

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

    return unless @get('isValid')

    unless @get('isNew')
      @get('content.transaction').commit()
      return

    meeting = Radium.Meeting.createRecord @get('data')

    @get('users').forEach (user) ->
      meeting.get('users').addObject user

    @get('contacts').forEach (contact) ->
      meeting.get('contacts').addObject contact

    meeting.get('transaction').commit()

  cancellationText: ( ->
    return if @get('isNew')

    topic = @get('topic')

    attendees = @get('attendees').map( (attendee) -> "@#{attendee.get('name')}").join(', ')

    "#{topic} with #{attendees} at #{@get('startsAt').toHumanFormatWithTime()}"
  ).property('topic', 'isNew')

  startsAtDidChange: ( ->
    startsAt = @get('startsAt')
    endsAt = @get('endsAt')

    return unless startsAt

    @set('meetingUsers.startsAt', startsAt)

    return unless Ember.DateTime.compare(endsAt, startsAt) == -1

    @set('endsAt', startsAt.advance(hour: 1))
  ).observes('startsAt')

  # FIXME: Review when using real ember-data
  attendeesDidChange: ( ->
    return if @get('calendarsOpen')
    return unless @get('isExpanded')
    return unless @get('users.length') && @get('startsAt')

    self = this

    @get('meetingUsers').forEach (user) =>
      if user
        meetings = Radium.Meeting.find(user: user, day: @get('startsAt'), meetingId: self.get('id'))
                                .filter (meeting) ->
                                  return false if meeting.get('isNew')
                                  meeting.get('users').contains(user)

        meetings.forEach (meeting) ->
          startsAt = meeting.get('startsAt').copy().advance(minute: -5)
          endsAt = meeting.get('endsAt').copy().advance(minute: 5)

          if self.get('startsAt').isBetween startsAt, endsAt
            self.set 'calendarsOpen', true

  ).observes('meetingUsers.[]', 'startsAt')

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

    attendees.addObject attendee

    @get('meetingUsers').pushObject attendee if attendee.constructor == Radium.User

  removeSelection: (user) ->
    users = @get('users')

    users.removeObject user

    @get('meetingUsers').removeObject user

  currentDate: ( ->
    @get('startsAt').toHumanFormat()
  ).property('startsAt')
