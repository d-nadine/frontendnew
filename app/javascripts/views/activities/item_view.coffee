Radium.ActivitiesItemView = Radium.View.extend
  classNameBindings: ['controller.tag', 'controller.eventName', ':activity', ':row']
  layoutName: 'activity'

  templateName: (->
    if @get('controller.isLoaded')
      "activities/#{@get('controller.tag')}"
    else
      "activities/loading"
  ).property('controller.tag')
