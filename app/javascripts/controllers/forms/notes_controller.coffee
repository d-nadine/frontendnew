Radium.FormsNoteController = Radium.FormController.extend
  actions:
    submit: ->
      @set 'isSubmitted', true
      return unless @get('isValid')
      @set 'justAdded', true

      @get('model').commit().then(( (confirmation) =>
        @send('flashSuccess', confirmation) if confirmation
      ),
      ((error) =>
        @send 'flashError', error
        error.deleteRecord()
      ))

      Ember.run.later(( =>
        @set 'isSubmitted', false
        @get('model').commit()
        @get('content').reset()

        @trigger 'formReset'
      ), 1200)

      return unless @get('isNew')

      @get('model').reset()
      @trigger('formReset')


  # isDisabled: (->
  #   return true if @get('justAdded')
  #   return true if @get('isSubmitted')
  #   false
  # ).property('justAdded')

  # showSaveButton: (->
  #   return false if @get('justAdded')

  #   @get('isNew')
  # ).property('justAdded')
