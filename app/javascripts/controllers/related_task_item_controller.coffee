Radium.RelatedTaskItemController = Radium.ObjectController.extend
  isTodo: (->
    @get('content') instanceof Radium.Todo
  ).property('content')

  isCall: (->
    @get('content') instanceof Radium.Call
  ).property('content')

  isMeeting: (->
    @get('content') instanceof Radium.Meeting
  ).property('content')
