Radium.MeetingAttendeeItemController = Radium.ObjectController.extend
  actions:
    cancelInvitation: (attendee) ->
      invitation = @findInviationFromAttendee attendee
      Ember.assert "No invitation found for attendee #{attendee.get('id') - attendee.constructor}", invitation

      name = invitation.get('person.name')

      invitation.one 'didDelete', =>
        @send 'flashSuccess', "#{name} has been removed from this meeting"

      invitation.deleteRecord()

      @get('store').commit()

    resendInvite: (attendee) ->
      alert 'No server side implementation yet'

  invited: Ember.computed.alias 'parentController.invited'
  isInvited: Ember.computed 'person', 'invited.[]', ->
    @get('invited').contains(@get('model'))

  findInviationFromAttendee: (attendee) ->
    @get('parentController.invitations').find (invitation) =>
      invitation.get("person") == attendee
