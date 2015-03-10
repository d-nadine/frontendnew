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
  actions:
    setForm: ->
      @set 'form.name', @get('model.name')
      @set 'form.title', @get('model.title')
      @set 'form.company', @get('model.company')
      @set 'form.companyName', @get('model.companyName')

  needs: ['companies']

  isValid: Ember.computed 'form.name', 'isEditing', ->
    return unless @get('isEditing')
    return if Ember.isEmpty @get('form.name')
    @get('form.name.length') >= 3

  form: Ember.computed ->
    Radium.ContactHeaderForm.create()
