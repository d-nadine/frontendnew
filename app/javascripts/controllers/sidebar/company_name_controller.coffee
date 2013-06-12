require 'controllers/sidebar/sidebar_base_controller'

Radium.CompanyNameForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['name']

  reset: ->
    @_super.apply this, arguments
    @set 'name', ''

Radium.SidebarCompanyNameController = Radium.SidebarBaseController.extend
  isValid: true

  setForm: ->
    @set 'form.name', @get('model.name')

  form: ( ->
    Radium.CompanyNameForm.create()
  ).property()
