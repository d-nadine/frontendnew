require 'controllers/sidebar/sidebar_base_controller'

Radium.EmailForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['email']

  reset: ->
    @_super.apply this, arguments
    @set 'email', ''

Radium.SidebarEmailController = Radium.SidebarBaseController.extend
  isValid: true

  setForm: ->
    @set 'form.email', @get('model.email')

  form: ( ->
    Radium.EmailForm.create()
  ).property()
