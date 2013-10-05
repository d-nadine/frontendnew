Radium.FormsMeetingController = Radium.FormController.extend BufferedProxy,
  actions:
    addSelection: (attendee) ->
      person = attendee.get('person')

      unless person
        displayName = attendee.get('name') || attendee.get('email')
        item = Ember.Object.create
                name: attendee.get('name'), email: attendee.get('email'), displayName: displayName, avatarKey: attendee.get('avatarKey')
        @get('contacts').addObject item
        return

      resource = if person.constructor == Radium.User then 'users' else 'contacts'

      attendees = @get(resource)

      return if attendees.find( (item) -> item == person)

      attendees.addObject person

      @get('meetingUsers').pushObject person if person.constructor == Radium.User

    removeSelection: (attendee) ->
      if @get('invited').contains attendee
        alert 'No API for existing attendees'
        event.preventDefault()
        return

      resource = if attendee.constructor == Radium.User then 'users' else 'contacts'

      attendees = @get(resource)

      return unless attendees.find( (item) -> item == attendee)

      attendees.removeObject attendee

      @get('meetingUsers').removeObject attendee if attendee.constructor == Radium.User

    showCalendars: ->
      @toggleProperty 'calendarsOpen'
      false

    deleteMeeting: ->
      model = if @get('model') instanceof Ember.ObjectController
                @get("model.model")
              else
                @get("model")

      model.deleteRecord()

      model.get('transaction').commit()

    submit:  ->
      @set 'isSubmitted', true

      return unless @get('isValid')

      @set 'isExpanded', false
      @set 'justAdded', true

      Ember.run.later( ( =>
        @set 'justAdded', false
        @set 'isSubmitted', false

        @applyBufferedChanges()

        if @get('isNew')
          @get('model').commit() 
          @get('attendees').clear()
        else
          @get('store').commit()

        @discardBufferedChanges()

        return unless @get('isNew')

        @get('model').reset()
        @trigger 'formReset'
      ), 1200)

  needs: ['companies','contacts','users']
  now: Ember.computed.alias('clock.now')
  companies: Ember.computed.alias('controllers.companies')
  userList: Ember.computed.alias 'controllers.users'
  contactList: Ember.computed.alias 'controllers.contacts'
  meetingUsers: null
  calendarsOpen: null

  init: ->
    @_super.apply this, arguments
    @set 'meetingUsers', Radium.MeetingUsers.create()
    @set 'meetingUsers.meetingId', this.get('id')
    @set 'calendarsOpen', false

  isEditable:( ->
    return false if @get('isSaving')
    return false if @get('isSubmitted')
    return true if @get('isNew')
    return false if @get('justAdded')
    return false if @get('hasElapsed')
    return true if @get('currentUser') is @get('organizer')
    return true unless @get('invitations.length')
    @get('invitations').find((invitation) => invitation.get('person') == @get('currentUser'))
  ).property('isSubmitted', 'isNew', 'justAdded', 'hasElapsed', 'isSaving')

  locations: ( ->
    @get('companies').map (company) -> 
      name = company.get('name')
      name += ", #{company.get('address')}" if company.get('address')

      Ember.Object.create(name: name)
  ).property('companies.[]')

  invited: ( ->
     @get('invitations').map (invitation) -> invitation.get('person')
  ).property('invitations.[]')

  attendees: ( ->
    attendees = Radium.PeopleList.listPeople(@get('users'), @get('contacts'))
    attendees.insertAt(0, @get('organizer')) unless @get('isNew')
    attendees
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

  isValid: ( ->
    return if Ember.isEmpty(@get('topic'))
    return if @get('startsAtIsInvalid')
    return if @get('startsAt').isBeforeToday()
    return if @get('endsAtIsInvalid')

    true
  ).property('topic', 'startsAt', 'endsAt', 'startsAtIsInvalid', 'endsAtIsInvalid', 'submitForm')

  startsAtIsInvalid: ( ->
    now = Ember.DateTime.create().advance(minute: -5)
    Ember.DateTime.compare(@get('startsAt'), now)  == -1
  ).property('startsAt')

  endsAtIsInvalid: ( ->
    Ember.DateTime.compare(@get('endsAt'), @get('startsAt')) == -1
  ).property('startsAt', 'endsAt')

  cancellationText: ( ->
    return if @get('isNew') || !@get('controller.model')

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
        meetings = Radium.Meeting.find(user_id: user.get('id'), day: @get('startsAt').toDateFormat())

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

  currentDate: ( ->
    @get('startsAt').toHumanFormat()
  ).property('startsAt')
