Radium.FormsMeetingController = Radium.FormController.extend BufferedProxy,
  Radium.AttachedFilesMixin,
  actions:
    addAttendeeToExistingMeeting: (attendee) ->
      person = attendee.get('person')

      if person
        invitation = Radium.Invitation.createRecord
                        status: 'pending'

        key = "_person#{person.constructor.humanize().capitalize()}"

        invitation.set key, person
        invitation.set 'meeting', @get('model')
      else
        invitation = Radium.Invitation.createRecord
                        email: attendee.get('email')
                        meeting: @get('model')
                        status: 'pending'
                        displayName: attendee.get('email')

        invitation.reloadAfterUpdateEvent()

        invitation.one 'becameInvalid', (result) =>
          @get('invitations').removeObject invitation
          @send 'flashError', result

        invitation.one 'becameError', (result) =>
          @get('invitations').removeObject invitation
          @send 'flashError', 'An error has occurred and the invitaiton cannot be sent.'

      @get('store').commit()

    addSelection: (attendee) ->
      person = attendee.get('person')

      if @get('isNew') && ! person
        displayName = attendee.get('name') || attendee.get('email')
        item = Ember.Object.create
                name: attendee.get('name'), email: attendee.get('email'), displayName: displayName, avatarKey: attendee.get('avatarKey'), isLoaded: true

        if @get('isNew')
          @get('contacts').addObject item
          return

      resource = if person.constructor == Radium.User then 'users' else 'contacts'

      attendees = @get(resource)

      return if attendees.find( (item) -> item == person)

      attendees.addObject person

      @get('meetingUsers').pushObject person if person.constructor == Radium.User

    removeSelection: (attendee) ->
      resource = if attendee.constructor == Radium.User then 'users' else 'contacts'

      attendees = @get(resource)

      return unless attendees.find( (item) -> item == attendee)

      attendees.removeObject attendee

      @get('meetingUsers.content').removeObject attendee if attendee.constructor == Radium.User

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

      if @get('parentController') instanceof Radium.CalendarTaskController
        @transitionToRoute 'calendar.index', model.get('startsAt')

      @send 'flashSuccess', 'The task has been deleted.'

    submit:  ->
      @set 'isSubmitted', true

      return unless @get('isValid')

      @set 'justAdded', true

      @set 'isExpanded', false

      Ember.run.later( ( =>
        @set 'justAdded', false
        @set 'isSubmitted', false

        @applyBufferedChanges()

        if @get('isNew')
          @get('model').commit() 
        else
          @get('store').commit()

        @discardBufferedChanges()

        if parentController = @get('parentController')
          if parentController instanceof Radium.CalendarTaskController
            parentController.get('controllers.calendarSidebar').notifyPropertyChange('items')
            @set('isExpanded', true)

        return unless @get('isNew')

        @get('model').reset()
        @get('model').resetDates()

        @trigger 'formReset'
      ), 1200)

  needs: ['companies','contacts','users', 'calendarSidebar']
  now: Ember.computed.alias('clock.now')
  companies: Ember.computed.alias('controllers.companies')
  userList: Ember.computed.alias 'controllers.users'
  contactList: Ember.computed.alias 'controllers.contacts'
  meetingUsers: null
  calendarsOpen: null

  init: ->
    @_super.apply this, arguments
    @set 'meetingUsers', Radium.MeetingUsers.create(parent: this)
    @set 'meetingUsers.meetingId', this.get('id')
    @set 'calendarsOpen', false

    return unless @get('isNew')

    @get('meetingUsers').pushObject @get('organizer')
    @set 'meetingUsers.startsAt', @get('model.startsAt')
    @get('content.users').forEach (user) => @get('meetingUsers').pushObject user

    if reference = @get('reference')
      if (reference.constructor is Radium.Contact) && reference.get('primaryEmail.value')
        @get('content.contacts').addObject(reference)

  isEditable:( ->
    return false if @get('isSaving')
    return false if @get('isSubmitted')
    return true if @get('isNew')
    return false if @get('justAdded')
    return false if @get('isFinished')
    return true if @get('currentUser') is @get('organizer')
    return true unless @get('invitations.length')
    @get('invitations').find((invitation) => invitation.get('person') == @get('currentUser'))
  ).property('isSubmitted', 'isNew', 'justAdded', 'isFinished', 'isSaving')

  locations: ( ->
    @get('companies').map (company) -> 
      name = company.get('name')
      name += ", #{company.get('address')}" if company.get('address')

      Ember.Object.create(name: name)
  ).property('companies.[]')

  invited: ( ->
     @get('invitations').map (invitation) -> invitation.get('person')
  ).property('invitations.[]')

  showTopicTextBox: ( ->
    return false if @get('justAdded')
    return true if @get('isNew')
    return false if @get('isDisabled')
    @get('isExpanded')
  ).property('isNew', 'isDisabled', 'isExpanded','justAdded')

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
    return if @get('isNew') || !@get('model') || @get('isSaving')

    topic = @get('topic')

    attendees = @get('attendees').map( (attendee) -> "@#{attendee.get('displayName')}").join(', ')

    "#{topic} with #{attendees} at #{@get('startsAt').toHumanFormatWithTime()}"
  ).property('topic', 'isNew', 'participants.[]')

  startsAtDidChange: ( ->
    return unless @get('startsAt') && @get('endsAt')

    Ember.DateTime.setRoundTime(this, 'startsAt')
    Ember.DateTime.setRoundTime(this, 'endsAt')

    endsAtGreater = Ember.DateTime.compare(@get('endsAt'), @get('startsAt')) != 1

    if (@get('endsAt').daysApart(@get('startsAt')) > 1) || endsAtGreater
      @set('endsAt', @get('startsAt').advance(hour: 1))

    @set('meetingUsers.startsAt', @get('startsAt'))
  ).observes('startsAt', 'endsAt', 'model.startsAt')

  participants: Radium.computed.aggregate('users', 'contacts')

  attendees: ( ->
    participants = @get('participants')

    attendees = participants.toArray()

    organizer = @get('organizer')

    unless organizer && attendees.contains organizer
      attendees.insertAt(0, organizer)

    attendees
  ).property('participants.[]', 'organizer')

  isExpandable: (->
    return false if @get('justAdded')
    !@get('isNew')
  ).property('isNew')

