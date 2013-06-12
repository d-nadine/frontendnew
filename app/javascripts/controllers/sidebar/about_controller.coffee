require 'controllers/sidebar/sidebar_base_controller'

Radium.AboutForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['notes']

  reset: ->
    @_super.apply this, arguments
    @set 'notes', ''

Radium.SidebarAboutController = Radium.SidebarBaseController.extend
  isValid: true

  setForm: ->
    @set 'form.notes', @get('model.notes')

  form: ( ->
    Radium.AboutForm.create()
  ).property()
