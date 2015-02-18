require 'controllers/sidebar/sidebar_base_controller'

Radium.ContactForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['contact']

  reset: ->
    @_super.apply this, arguments
    @set 'contact', null

Radium.SidebarContactPickerController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set 'form.contact', @get('model.contact')

  isValid: Ember.computed 'form.contact',  'isEditing', ->
    return unless @get('isEditing')
    return if Ember.isEmpty @get('form.contact')
    true

  form: Ember.computed ->
    Radium.ContactForm.create()
