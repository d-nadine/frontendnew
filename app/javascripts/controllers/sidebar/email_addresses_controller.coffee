require 'controllers/sidebar/sidebar_base_controller'

Radium.EmailAddressesForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  reset: ->
    @_super.apply this, arguments

Radium.SidebarEmailAddressesController = Radium.SidebarBaseController.extend
  isValid: true

  setForm: ->
    console.log 'emails'

  form: ( ->
    Radium.EmailAddressesForm.create()
  ).property()
