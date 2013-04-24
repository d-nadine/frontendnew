Radium.RelatedTaskItemController = Radium.ObjectController.extend
  isTodo: (->
    @get('content') instanceof Radium.Todo
  ).property('content.kind')

  isCall: (->
    @get('content') instanceof Radium.Call
  ).property('content.kind')

  isMeeting: (->
    @get('content') instanceof Radium.Meeting
  ).property('content')
