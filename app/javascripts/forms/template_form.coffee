require 'forms/form'
require 'forms/forms_attachment_mixin'

Radium.TemplateForm = Radium.Form.extend Radium.FormsAttachmentMixin,
  Radium.EmailPropertiesMixin,
  Ember.Evented,


  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  reset: ->
    @set('id', null)
    @set('isNew', true)
    @set('subject', '')
    @set('html', '')
    @trigger 'reset'
    @_super.apply this, arguments

  data: Ember.computed( ->
    subject: @get('subject')
    html: @get('html')

    files: @get('files').mapProperty('file')

    attachedFiles: Ember.A()
    bucket: @get('bucket')
  ).volatile()

  isValid: Ember.computed 'to.[]', 'html', ->
    @get('to.length') && @get('html.length')
