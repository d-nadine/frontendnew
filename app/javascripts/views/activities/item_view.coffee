Radium.ActivitiesItemView = Radium.View.extend
  classNameBindings: ['controller.tag', 'controller.eventName', ':activity', ':row']
  layoutName: 'activity'

  templateName: (->
    console.log "activities/#{@get('controller.tag')}"
    "activities/#{@get('controller.tag')}"
  ).property('controller.tag')
