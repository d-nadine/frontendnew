Radium.NextTaskController = Radium.ObjectController.extend
  isCall: (->
    @get('kind') is 'call'
  ).property('content')

  isTodo: (->
    @get('kind') is 'general'
  ).property('content')

  isMeeting: (->
    @get('content') instanceof Radium.Meeting
  ).property('content')
