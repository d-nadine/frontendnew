Radium.ActivitiesItemView = Radium.View.extend
  classNameBindings: ['controller.tag', 'controller.eventName', ':activity', ':row']
  layoutName: 'activity'

  templateName: (->
    "activities/#{@get('controller.tag')}"
  ).property('controller.tag')
