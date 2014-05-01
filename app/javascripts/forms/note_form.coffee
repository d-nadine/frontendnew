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
    return unless @get('isNew')
    return new Ember.RSVP.Promise (resolve, reject)=>
      record = Radium.Note.createRecord @get('data')

      record.one 'didCreate', (result) =>
        @get('reference').reload()
        result.set 'newTask', true
        resolve(result)

      record.one 'becameInvalid', (result) =>
        result.reset()
        reject(result)

      record.one 'becameError', (result)  ->
        result.reset()
        result.get('transaction').rollback()
        reject("An error has occurred and the #{result.get('typeName')} could not be created.")

      @get('store').commit()
