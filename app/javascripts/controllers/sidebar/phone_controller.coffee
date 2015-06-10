require 'controllers/sidebar/sidebar_base_controller'

Radium.PhoneForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['phone']

  reset: ->
    @_super.apply this, arguments
    @set 'phone', ''

Radium.SidebarPhoneController = Radium.SidebarBaseController.extend
  actions:
    setProperties: ->
      @set('form.phone', '') if @get('form.phone') == "+1"
      @_super.apply this, arguments

    setForm: ->
      @set 'form.phone', @get('model.phone')

  isValid: true

  form: Ember.computed ->
    Radium.PhoneForm.create()
