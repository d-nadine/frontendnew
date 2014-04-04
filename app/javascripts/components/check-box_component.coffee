Radium.CheckBoxComponent = Ember.Component.extend
  tagName: 'label'
  classNames: 'check-box'
  click: (event) ->
    event.stopPropagation()
    @toggleProperty('checked')

    # FIXME: I should not have to schedule this call
    # I created this issue
    # https://github.com/emberjs/ember.js/issues/4385#issuecomment-38055914
    Ember.run.schedule('actions', this, 'sendNotification')

  sendNotification: ->
    @sendAction 'sendCheck'
