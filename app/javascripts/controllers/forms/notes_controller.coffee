Radium.FormsNoteController = Radium.FormController.extend
  actions:
    submit: ->
      @set 'isSubmitted', true
      return unless @get('isValid')
      @set 'justAdded', true

      body = @get('model.body').reformatHtml()

      @set('model.body', body)
      @get('model').commit().then (confirmation) =>
        @flashMessenger.success("Note Added!") if confirmation
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
