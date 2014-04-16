require 'forms/form'
Radium.NoteForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    reference: @get('reference')
    body: @get('body')
  ).property().volatile()
  isValid: Ember.computed.notEmpty 'body'
  reset: ->
    @_super.apply this, arguments
    @set 'body', ''
    @set('submitForm', false)
  commit: ->
    Radium.Note.createRecord @get('data')
    @get('store').commit()
