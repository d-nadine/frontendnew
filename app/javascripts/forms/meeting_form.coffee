require 'forms/form'
require 'forms/forms_attachment_mixin'

Radium.MeetingForm = Radium.Form.extend Radium.FormsAttachmentMixin,
  data: ( ->
    topic: @get('topic')
    location: @get('location')
    startsAt: @get('startsAt')
    endsAt: @get('endsAt')
    invitations: Ember.A()
    files: @get('files').map (file) =>
      file.get('file')

    attachedFiles: Ember.A()
    bucket: @get('bucket')
  ).property().volatile()

  reset: ->
    return unless @get('isNew')
    @_super.apply this, arguments
    @get('users').clear()
    @get('contacts').clear()
    @get('invitations').clear()
    @set('submitForm', false)

  commit: ->
    isNew = @get('isNew')

    meeting = if isNew
                Radium.CreateMeeting.createRecord @get('data')
              else
                @get('model')

    users = @get('users').slice()
    contacts = @get('contacts').slice()
    reference = @get('reference')

    if isNew
      @get('users').forEach (user) =>
        meeting.get('invitations').addObject person: type: 'user', id: user.get('id')

      @get('contacts').forEach (contact) =>
        if contact.get('id')
          meeting.get('invitations').addObject person: type: contact.get('typeName'), id: contact.get('id')
        else
          meeting.get('invitations').addObject email: contact.get('email')

      if @get('reference') && @get('reference.constructor') is Radium.Contact
          meeting.get('invitations').addObject person: type: 'contact', id: @get('reference.id')

      @setFilesOnModel(meeting)

    meeting.one 'didCreate', (result) =>
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

      array.pushObject(reference) if reference

      array.forEach (model) =>
        model.reload() unless model.get('currentState.stateName') == "root.loaded.reloading"

    @get('store').commit()
