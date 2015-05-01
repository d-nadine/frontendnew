require 'mixins/editor_mixin'

Radium.TemplateEditorComponent = Ember.Component.extend Radium.EditorMixin,
  actions:
    saveTemplate: ->
      @sendAction "action", @get('form')

      false

    deleteFromEditor: ->
      @sendAction 'deleteFromEditor'

      false

  _setup: Ember.on 'didInsertElement', ->
    Ember.run.scheduleOnce 'afterRender', this, '_afterSetup'

  _afterSetup: ->
    Ember.run.next =>
      @$('.subject-wrap input[type=text]').get(0).focus()

  subjectView: Ember.TextField.extend
    classNameBindings: ['isInvalid']
    isInvalid: Ember.computed 'targetObject.form.isSubmitted', 'targetObject.form.subject.length', ->
      return unless @get('targetObject.form.isSubmitted')

      !!!@get('targetObject.form.subject.length')

  messageIsInvalid: Ember.computed 'form.isSubmitted', 'form.html.length', ->
    return false unless @get('form.isSubmitted')

    message = @get('form.html') || ''

    !!!message.length
