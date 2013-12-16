Radium.CheckBoxComponent = Ember.Component.extend
  tagName: 'label'
  classNames: 'check-box'
  click: (event) ->
    event.stopPropagation()
    @toggleProperty('checked')

    Ember.run.next =>
      @sendNotification()

  sendNotification: ->
    @sendAction 'sendCheck'
