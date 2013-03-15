Radium.NextTaskController = Ember.ObjectController.extend
  isCall: (->
    return unless @get('content') instanceof Radium.Todo
    @get('kind') is 'call'
  ).property('content')

  isTodo: (->
    return unless @get('content') instanceof Radium.Todo
    @get('kind') isnt 'call'
  ).property('content')

  isMeeting: (->
    @get('content') instanceof Radium.Meeting
  ).property('content')
