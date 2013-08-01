Radium.FormsDiscussionView = Radium.FormView.extend
  textbox: Radium.MentionFieldView.extend
    classNameBindings: ['value:is-valid', 'isInvalid']
    valueBinding: 'controller.topic'
    isSubmitted: Ember.computed.alias('controller.isSubmitted')

    placeholder: "New discussion"
    disabledBinding: 'controller.isDisabled'

    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

  onFormReset: ->
    @get('text').reset()
