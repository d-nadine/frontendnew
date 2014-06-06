require 'controllers/sidebar/sidebar_base_controller'

Radium.DatePickerForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['expectedCloseDate']

  reset: ->
    @_super.apply this, arguments
    @set 'expectedCloseDate', null

Radium.SidebarDatePickerController = Radium.SidebarBaseController.extend
  actions:
    actions:
      setForm: ->
        @set 'form.expectedCloseDate', @get('model.expectedCloseDate')
  form: ( ->
    Radium.DatePickerForm.create()
  ).property()
