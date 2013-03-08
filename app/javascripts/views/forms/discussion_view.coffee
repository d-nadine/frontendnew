Radium.FormsDiscussionView = Radium.FormView.extend
  textbox: Radium.MentionFieldView.extend
    classNameBindings: ['value:is-valid', 'isInvalid']
    valueBinding: 'controller.text'
    isSubmitted: Ember.computed.alias('controller.isSubmitted')

    placeholder: """
      Add people to discussion by tagging them with "@" 
      for example @John. They'll be notified when someone
      comments.
    """
    disabledBinding: 'controller.isDisabled'

    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

  onFormReset: ->
    @get('text').reset()
