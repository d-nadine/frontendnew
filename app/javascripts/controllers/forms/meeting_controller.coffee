Radium.FormsMeetingController = Radium.FormController.extend
  needs: ['groups','contacts','users']
  now: Ember.computed.alias('clock.now')
  groups: Ember.computed.alias('controllers.groups')
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
    userList = @get('userList').mapProperty('content')
    contactList = @get('contactList')

    Radium.PeopleList.listPeople(userList, contactList)
      .filter (person) -> person.get('email')
  ).property('userList.[]', 'contactList.[]')

  isEditable:( ->
    return false if @get('isSubmitted')
    return true if @get('isNew')
    return false unless @get('content.isEditable')
    return false if @get('justAdded')
    return false if @get('hasElapsed')
    true
  ).property('isSubmitted', 'isNew', 'justAdded', 'hasElapsed')

  locations: ( ->
    @get('groups').map (group) -> Ember.Object.create
                                    name: "#{group.get('name')}, #{group.get('address')}"
  ).property()

  attendees: ( ->
    Radium.PeopleList.listPeople(@get('users'), @get('contacts'))
  ).property('users.[]', 'contacts.[]')

  showTopicTextBox: ( ->
    return false if @get('justAdded')
    return true if @get('isNew')
    return false if @get('isDisabled')
    @get('isExpanded')
  ).property('isNew', 'isDisabled', 'isExpanded','justAdded')

  hasElapsed: ( ->
    return unless @get('startsAt')

    @get('startsAt').isBeforeToday()
  ).property('startsAt', 'now')

  submit:  ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    @set 'isExpanded', false
    @set 'justAdded', true

    Ember.run.later( ( =>
      @set 'justAdded', false
      @set 'isSubmitted', false

      @get('model').commit()
      @get('model').reset()

      @trigger 'formReset'
    ), 1200)

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
        meetings = Radium.Meeting.find(user: user, day: @get('startsAt'), exclude: self.get('id'))

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

  removeSelection: (attendee) ->
    resource = if attendee.constructor == Radium.User then 'users' else 'contacts'

    attendees = @get(resource)

    return unless attendees.find( (item) -> item == attendee)

    attendees.removeObject attendee

    @get('meetingUsers').removeObject attendee if attendee.constructor == Radium.User

  currentDate: ( ->
    @get('startsAt').toHumanFormat()
  ).property('startsAt')
