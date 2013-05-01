Radium.ActivitiesItemView = Radium.View.extend
  templateName: (->
    "activities/#{@get('content.tag')}"
  ).property('content.tag')
