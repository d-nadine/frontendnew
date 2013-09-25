require 'controllers/sidebar/sidebar_base_controller'

Radium.NameForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['name']

  reset: ->
    @_super.apply this, arguments
    @set 'name', ''

Radium.SidebarNameController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set 'form.name', @get('model.name')

  isValid: true

  form: ( ->
    Radium.NameForm.create()
  ).property()
