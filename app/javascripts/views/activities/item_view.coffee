Radium.ActivitiesItemView = Radium.View.extend
  classNameBindings: ['controller.tag', ':activity', ':row']
  layoutName: 'activity'

  templateName: (->
    "activities/#{@get('controller.tag')}"
  ).property('controller.tag')
