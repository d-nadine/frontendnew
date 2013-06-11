require 'controllers/sidebar/multiple_base_controller'

Radium.EmailAddressesForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  reset: ->
    @_super.apply this, arguments
    @set 'emailAddresses', Ember.A()

Radium.SidebarEmailAddressesController = Radium.MultipleBaseController.extend
  isValid: true
  recordArray: 'emailAddresses'

  form: ( ->
    Radium.EmailAddressesForm.create()
  ).property()
