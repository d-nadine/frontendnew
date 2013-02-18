Radium.FormsMeetingView = Ember.View.extend
<<<<<<< HEAD
  templateName: 'unimplemented'
=======
  checkbox: Radium.FormsCheckboxView.extend()

  topicField: Radium.MentionFieldView.extend
    placeholder: 'Add meeting topic'
    valueBinding: 'controller.topic'

  topicField: Radium.MentionFieldView.extend
    classNameBindings: [':meeting']
    placeholder: 'Add meeting topic'
>>>>>>> add top level meeting form
