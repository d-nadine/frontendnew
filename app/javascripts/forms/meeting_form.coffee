require 'forms/form'

Radium.MeetingForm = Radium.Form.extend
  data: ( ->
    topic: @get('topic')
    location: @get('location')
    startsAt: @get('startsAt')
    endsAt: @get('endsAt')
    invitations: Ember.A()
  ).property().volatile()

  reset: ->
    return unless @get('isNew')
    @_super.apply this, arguments
    @get('users').clear()
    @get('contacts').clear()
    @get('invitations').clear()

  commit: ->
    isNew = @get('isNew')

    meeting = if isNew
                Radium.CreateMeeting.createRecord @get('data')
              else
                @get('model')

    if isNew
      @get('users').forEach (user) =>
        meeting.get('invitations').addObject person: type: 'user', id: user.get('id')

      @get('contacts').forEach (contact) =>
        if contact.get('id')
          meeting.get('invitations').addObject person: type: 'contact', id: contact.get('id')
        else
          meeting.get('invitations').addObject email: contact.get('email')

      if @get('reference') && @get('reference.constructor') is Radium.Contact
          meeting.get('invitations').addObject person: type: 'contact', id: @get('reference.id')

    @get('store').commit()
