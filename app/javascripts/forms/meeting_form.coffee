require 'forms/form'
require 'forms/forms_attachment_mixin'

Radium.MeetingForm = Radium.Form.extend Radium.FormsAttachmentMixin,
  data: ( ->
    topic: @get('topic')
    description: @get('description')
    location: @get('location')
    startsAt: @get('startsAt')
    endsAt: @get('endsAt')
    invitations: Ember.A()
    files: @get('files').mapProperty('file')

    attachedFiles: Ember.A()
    bucket: @get('bucket')
  ).property().volatile()

  reset: ->
    return unless @get('isNew')
    @_super.apply this, arguments
    @get('description', "")
    @get('users').clear()
    @get('contacts').clear()
    @get('invitations').clear()
    @set('submitForm', false)
    @set('organizer', @get('currentUser'))

  resetDates: ->
    date = Ember.DateTime.create().getRoundTime()
    @set('startsAt', date.advance(hour: 1))
    @set('endsAt', date.advance(hour: 2))


  commit: ->
    isNew = @get('isNew')

    meeting = if isNew
                Radium.CreateMeeting.createRecord @get('data')
              else
                @get('model')

    users = @get('users').slice()
    contacts = @get('contacts').slice()

    if isNew
      @get('users').forEach (user) ->
        meeting.get('invitations').addObject person: type: 'user', id: user.get('id')

      @get('contacts').forEach (contact) ->
        if contact.get('id')
          meeting.get('invitations').addObject person: type: contact.get('typeName'), id: contact.get('id')
        else
          meeting.get('invitations').addObject email: contact.get('email')

      @setFilesOnModel(meeting)

    meeting.save().then (result) =>
      observer = ->
        if result.get('meeting')
          result.set 'meeting.newTask', true
          result.removeObserver 'meeting', observer

      result.addObserver 'meeting', observer

      # FIXME: client side hack.  The server should return the meeting
      # with the relationships set
      currentUser = @get('currentUser.model')

      array = Ember.A()

      array.pushObject currentUser

      users.forEach (user) ->
        unless user == currentUser
          array.pushObject user

      contacts.forEach (contact) ->
        array.pushObject(contact) if contact.reload

      array.forEach (model) ->
        model.reload() unless model.get('currentState.stateName') == "root.loaded.reloading"
