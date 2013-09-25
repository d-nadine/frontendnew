require 'controllers/sidebar/sidebar_base_controller'

Radium.AmountForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['value']

  reset: ->
    @_super.apply this, arguments
    @set 'value', ''

Radium.SidebarAmountController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set 'form.value', @get('model.value')

  isValid: Ember.computed.bool 'form.value'

  form: ( ->
    Radium.AmountForm.create()
  ).property()
