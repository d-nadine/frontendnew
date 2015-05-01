Radium.MentionFieldView = Ember.View.extend
  attributeBindings: ['readonly']
  classNameBindings: ['disabled:is-disabled', ':mention-field-view']
  sourceBinding: 'controller.controllers.users'

  template: Ember.Handlebars.compile """
    {{view view.textArea}}
  """

  textArea: Ember.TextArea.extend
    rows: 1
    tabIndexBinding: 'parentView.tabIndex'
    placeholderBinding: 'parentView.placeholder'
    readonlyBinding: 'parentView.readonly'
    valueBinding: 'parentView.value'

    keyDown: (event) ->
      return unless event.keyCode is 13

      event.preventDefault()

    insertNewline: (event) ->
      @get('parentView.controller').send 'submit'
