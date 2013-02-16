Radium.FormsDiscussionView = Ember.View.extend
  textbox: Radium.MentionFieldView.extend
    classNameBindings: ['value:is-valid']
    valueBinding: 'controller.text'
    placeholder: """
      Add people to discussion by tagging them with "@" 
      for example @John. They'll be notified when someone
      comments.
    """
    disabledBinding: 'controller.isDisabled'
