Radium.EmailFormComponent = Ember.Component.extend
  actions:
    expandList: (section) ->
      @set("show#{section.capitalize()}", true)

  isEditable: true
  isSubmitted: false

  to: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.form.to'
    showAvatar: false
    isInvalid: Ember.computed 'controller.isSubmitted', 'controller.to.[]', ->
      return unless @get('controller.isSubmitted')

      @get('controller.form.to.length') == 0

    isValid: Ember.computed 'controller.form.to.[]', ->
      @get('controller.form.to.length') > 0

  cc: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.form.cc'
    showAvatar: false

  bcc: Radium.EmailAsyncAutocompleteView.extend
    classNameBindings: [':email']
    sourceBinding: 'controller.form.bcc'
    showAvatar: false
