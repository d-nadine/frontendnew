require 'controllers/sidebar/sidebar_base_controller'

Radium.UserHeaderForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['firstName','lastName','title']

  reset: ->
    @_super.apply this, arguments
    @set 'firstName', ''
    @set 'lastName', ''
    @set 'title', ''

Radium.SidebarUserHeaderController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set 'form.firstName', @get('model.firstName')
      @set 'form.lastName', @get('model.lastName')
      @set 'form.title', @get('model.title')

  needs: ['companies']

  isValid: ( ->
    return unless @get('isEditing')
    return if Ember.isEmpty @get('form.firstName')
    @get('form.firstName.length') >= 3
    @get('form.lastName.length') >= 3
  ).property('form.firstName', 'isEditing')

  form: ( ->
    Radium.UserHeaderForm.create()
  ).property()
