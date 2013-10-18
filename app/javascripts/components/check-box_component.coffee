Radium.CheckBoxComponent = Ember.Component.extend
  tagName: 'label'
  classNames: 'check-box'
  click: (event) ->
    event.stopPropagation()
    @sendNotification()

  sendNotification: ->
    @sendAction 'sendCheck'
