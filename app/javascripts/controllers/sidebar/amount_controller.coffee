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

    setProperties: ->
      model = @get('model')

      amount = accounting.unformat @get('form.value')
      model.set 'value', amount

  isValid: Ember.computed 'form.value', ->
    value = accounting.unformat @get('form.value')

    parseInt(value) != 0

  form: Ember.computed ->
    Radium.AmountForm.create()
