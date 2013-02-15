Radium.FormsTodoFieldView = Radium.MentionFieldView.extend
  classNameBindings: ['value:is-valid', 'isInvalid', ':todo']
  valueBinding: 'controller.description'
  dateBinding: 'controller.finishBy'

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  isInvalid: (->
    Ember.isEmpty(@get('value')) && @get('isSubmitted')
  ).property('value', 'isSubmitted')

  referenceName: Ember.computed.alias('controller.reference.name')

  disabled: (->
    if @get('controller.isDisabled')
      true
    else if(!@get('controller.isNew') && !@get('controller.isExpanded'))
      true
    else
      false
  ).property('controller.isNew', 'controller.isExpanded')

