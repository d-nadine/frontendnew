require 'controllers/sidebar/sidebar_base_controller'

Radium.NotesForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments

  properties: ['notes']

  reset: ->
    @_super.apply this, arguments
    @set 'notes', ''

Radium.SidebarNotesController = Radium.SidebarBaseController.extend
  actions:
    setForm: ->
      @set 'form.notes', @get('model.notes')

  isValid: true

  form: ( ->
    Radium.NotesForm.create()
  ).property()
