require 'controllers/sidebar/sidebar_base_controller'

Radium.UserForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['user']

  reset: ->
    @_super.apply this, arguments
    @set 'user', null

Radium.SidebarUserController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set 'form.user', @get('model.user')

  needs: ['users', 'accountSettings']

  isValid: ( ->
    return unless @get('isEditing')
    return if Ember.isEmpty @get('form.user')
    true
  ).property('form.user',  'isEditing')

  form: ( ->
    Radium.UserForm.create()
  ).property()
