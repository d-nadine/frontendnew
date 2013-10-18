Radium.CheckBoxComponent = Ember.Component.extend
  tagName: 'label'
  classNames: 'check-box'
  click: (event) ->
    @controller.sendAction 'sendCheck'
    event.stopPropagation()
