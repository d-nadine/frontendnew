require 'controllers/sidebar/sidebar_base_controller'
require 'mixins/user_combobox_props'

Radium.UserForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['user']

  reset: ->
    @_super.apply this, arguments
    @set 'user', null

Radium.SidebarUserController = Radium.SidebarBaseController.extend Radium.UserComboboxProps,
  actions:
    setForm: ->
      @set 'form.user', @get('model.user')

  needs: ['users', 'accountSettings']

  isValid: Ember.computed 'form.user', 'isEditing', ->
    return unless @get('isEditing')
    return if Ember.isEmpty @get('form.user')
    true

  form: Ember.computed ->
    Radium.UserForm.create()

  isSubmitted: true
