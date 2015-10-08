require 'mixins/editor_mixin'

Radium.TemplateEditorComponent = Ember.Component.extend Radium.EditorMixin,
  actions:
    sendTemplateTest: ->
      form = @get('form')
      parent = @get('parent')
      currentUser = parent.get('currentUser')
      emailForm = Ember.Object.create
                    to: Ember.A()
                    subject: ''
                    html: ''
                    isValid: true

      if !form.get('subject.length') || !form.get('html.length')
        return parent.send 'flashError', 'You must supply a subject line and an email body for an email template.'

      emailForm.setFilesOnModel = ->
      form.reset = ->

      emailForm.get('to').pushObject(currentUser.get('email'))
      emailForm.set 'subject', form.get('subject')
      emailForm.set 'html', form.get('html')

      emailForm.set 'data',
        to: emailForm.get('to')
        subject: emailForm.get('subject')
        html: emailForm.get('html')

      @sendAction 'saveEmail', emailForm, dontTransition: true, dontAdd: true

      @get('parent').send 'flashSuccess', 'sample email sent'
      false

    saveTemplate: ->
      @sendAction "action", @get('form')

      false

    deleteFromEditor: ->
      @sendAction 'deleteFromEditor'

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    Ember.run.scheduleOnce 'afterRender', this, '_afterSetup'

  _tearDown: ->
    @_super.apply this, arguments
    @newEmail.reset()

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
