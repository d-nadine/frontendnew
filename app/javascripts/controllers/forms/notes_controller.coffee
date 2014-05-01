Radium.FormsNoteController = Radium.FormController.extend
  actions:
    submit: ->
      @set 'isSubmitted', true
      return unless @get('isValid')
      @set 'justAdded', true

      @get('model').commit().then (confirmation) =>
        @send('flashSuccess', "Note added") if confirmation
      ,
      (error) =>
        @send 'flashError', error
        error.deleteRecord()

      Ember.run.later =>
        @set 'isSubmitted', false
        @get('content').reset()
        @set 'justAdded', false
        @trigger 'formReset'
      , 1200

      return unless @get('isNew')

      @get('model').reset()
      @trigger('formReset')
