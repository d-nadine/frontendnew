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
  actions:
    setForm: ->
      @set 'form.email', @get('model.email')

  isValid: true

  form: ( ->
    Radium.EmailForm.create()
  ).property()
