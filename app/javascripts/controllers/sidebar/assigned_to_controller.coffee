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
  actions:
    setForm: ->
      @set 'form.source', @get('model.source')
      @set 'form.user', @get('model.user')

  needs: ['users', 'accountSettings']

  isValid: Ember.computed 'form.source', 'form.user',  'isEditing', ->
    return unless @get('isEditing')
    return if Ember.isEmpty @get('form.source')
    return if Ember.isEmpty @get('form.user')
    true

  form: Ember.computed ->
    Radium.ContactAssignedToForm.create()
