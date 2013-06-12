require 'controllers/sidebar/sidebar_base_controller'

Radium.AboutForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['about']

  reset: ->
    @_super.apply this, arguments
    @set 'about', ''

Radium.SidebarAboutController = Radium.SidebarBaseController.extend
  isValid: true

  setForm: ->
    @set 'form.about', @get('model.about')

  form: ( ->
    Radium.AboutForm.create()
  ).property()
