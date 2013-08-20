Radium.ActivitiesItemView = Radium.View.extend
  classNameBindings: ['controller.tag', 'controller.eventName', ':activity', ':row']
  layoutName: 'activity'

  templateName: (->
    console.log "activities/#{@get('controller.tag')}"
    if @get('controller.isLoaded')
      "activities/#{@get('controller.tag')}"
    else
      "activities/loading}"
  ).property('controller.tag')
