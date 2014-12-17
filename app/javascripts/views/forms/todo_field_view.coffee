Radium.FormsTodoFieldView = Radium.MentionFieldView.extend
  classNameBindings: ['value:is-valid', 'isInvalid', ':todo']
  valueBinding: 'controller.description'
  dateBinding: 'controller.finishBy'

  isSubmitted: Ember.computed.oneWay('controller.isSubmitted')
  isInvalid: Ember.computed 'value', 'isSubmitted', ->
    Ember.isEmpty(@get('value')) && @get('isSubmitted')

  referenceName: Ember.computed.oneWay('controller.reference.name')
