Radium.ActivitiesInvitationController = Radium.ObjectController.extend
  isCreate: Ember.computed.is 'event', 'create'

  invitation: Ember.computed.alias 'reference'

  meeting: ( ->
    return unless @get('meta.meetingId')

    Radium.Meeting.all().find (meeting) =>
      meeting.get('id') == @get('meta.meetingId').toString()
  ).property('meta.meetingId')

  icon: (->
    switch @get('event')
      when 'create' then 'star'
  ).property('event')
