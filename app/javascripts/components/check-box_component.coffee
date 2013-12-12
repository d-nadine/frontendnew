Radium.CheckBoxComponent = Ember.Component.extend
  tagName: 'label'
  classNames: 'check-box'
  click: (event) ->
    event.stopPropagation()
    @toggleProperty('checked')
    @sendNotification()

  sendNotification: ->
    @sendAction 'sendCheck'
