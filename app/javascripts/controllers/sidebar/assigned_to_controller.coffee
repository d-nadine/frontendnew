require 'controllers/sidebar/sidebar_base_controller'

Radium.ContactAssignedToForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['source','user']

  reset: ->
    @_super.apply this, arguments
    @set 'source', ''
    @set 'user', null

Radium.SidebarAssignedToController = Radium.SidebarBaseController.extend
  needs: ['users', 'accountSettings']

  isValid: ( ->
    return unless @get('isEditing')
    return if Ember.isEmpty @get('form.source')
    return if Ember.isEmpty @get('form.user')
    true
  ).property('form.source', 'form.user',  'isEditing')

  setForm: ->
    @set 'form.source', @get('model.source')
    @set 'form.user', @get('model.user')

  form: ( ->
    Radium.ContactAssignedToForm.create()
  ).property()
