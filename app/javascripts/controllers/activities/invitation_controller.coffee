Radium.ActivitiesInvitationController = Radium.ActivityBaseController.extend
  isCreate: Ember.computed.is 'event', 'create'
  isConfirm: Ember.computed.is 'event', 'confirm'

  invitation: Ember.computed.alias 'reference'

  meeting: ( ->
    return unless @get('meta.meetingId')

    Radium.Meeting.all().find (meeting) =>
      meeting.get('id') == @get('meta.meetingId').toString()
  ).property('meta.meetingId')

  icon: (->
    switch @get('event')
      when 'create', 'confirm' then 'star'
  ).property('event')
