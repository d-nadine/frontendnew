Radium.MeetingAttendeeItemController = Radium.ObjectController.extend
  invited: Ember.computed.alias 'parentController.invited'
  isInvited: Ember.computed 'person', 'invited.[]', ->
    @get('invited').contains(@get('model'))
