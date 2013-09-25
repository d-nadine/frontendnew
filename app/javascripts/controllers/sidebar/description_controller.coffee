require 'controllers/sidebar/sidebar_base_controller'

Radium.DescriptionForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['description']

  reset: ->
    @_super.apply this, arguments
    @set 'description', ''

Radium.SidebarDescriptionController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set 'form.description', @get('model.description')

  isValid: true

  form: ( ->
    Radium.DescriptionForm.create()
  ).property()
