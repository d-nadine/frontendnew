require 'controllers/sidebar/sidebar_base_controller'

Radium.ContactHeaderForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['name','title','companyName']

  reset: ->
    @_super.apply this, arguments
    @set 'name', ''
    @set 'title', ''
    @set 'company', null
    @set 'companyName', ''

Radium.SidebarContactHeaderController = Radium.SidebarBaseController.extend
  needs: ['companies']
  isEditable: true

  isValid: ( ->
    return unless @get('isEditing')
    return if Ember.isEmpty @get('form.name')
    @get('form.name.length') >= 3
  ).property('form.name', 'isEditing')

  startEditing: ->
    return if @get('isSaving')
    @get('form').reset()
    @set 'form.name', @get('model.name')
    @set 'form.title', @get('model.title')
    @set 'form.company', @get('model.company')
    @set 'form.companyName', @get('model.companyName')

  stopEditing: ->
    return if @get('isSaving')
    return unless @get('isValid')
    @commit()

  form: ( ->
    Radium.ContactHeaderForm.create()
  ).property()
