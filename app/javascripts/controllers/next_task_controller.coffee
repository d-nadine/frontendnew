Radium.NextTaskController = Radium.ObjectController.extend
  isCall: (->
    @get('content') instanceof Radium.Call
  ).property('content')

  isTodo: (->
    @get('content') instanceof Radium.Todo
  ).property('content')

  isMeeting: (->
    @get('content') instanceof Radium.Meeting
  ).property('content')
