require 'controllers/sidebar/sidebar_base_controller'

Radium.PhoneNumbersForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  reset: ->
    @_super.apply this, arguments
    @set 'phoneNumbers', Ember.A()

Radium.SidebarPhoneNumbersController = Radium.MultipleBaseController.extend
  isValid: true
  recordArray: 'phoneNumbers'

  form: ( ->
    Radium.PhoneNumbersForm.create()
  ).property()
