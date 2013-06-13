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
  isValid: true

  setForm: ->
    @set 'form.description', @get('model.description')

  form: ( ->
    Radium.DescriptionForm.create()
  ).property()
