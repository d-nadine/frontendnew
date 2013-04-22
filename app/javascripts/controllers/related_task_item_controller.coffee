Radium.RelatedTaskItemController = Radium.ObjectController.extend
  isTodo: (->
    @get('kind') is 'general'
  ).property('content.kind')

  isCall: (->
    @get('kind') is 'call'
  ).property('content.kind')

  isMeeting: (->
    @get('content') instanceof Radium.Meeting
  ).property('content')
