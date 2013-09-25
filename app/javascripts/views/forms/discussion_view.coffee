Radium.FormsDiscussionView = Radium.FormView.extend
  textbox: Radium.MentionFieldView.extend
    classNameBindings: ['value:is-valid', 'isInvalid']
    valueBinding: 'targetObject.topic'
    isSubmitted: Ember.computed.alias('targetObject.isSubmitted')

    placeholder: "New discussion"
    disabledBinding: 'targetObject.isDisabled'

    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

  onFormReset: ->
    @get('text').reset()
