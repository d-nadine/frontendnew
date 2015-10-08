Radium.NextTaskController = Radium.ObjectController.extend
  isTodo: Ember.computed 'content', ->
    @get('content') instanceof Radium.Todo

  isMeeting: Ember.computed 'content', ->
    @get('content') instanceof Radium.Meeting
