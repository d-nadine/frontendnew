Radium.FormsDiscussionController = Radium.ObjectController.extend Ember.Evented,
  isDisabled: (->
    return true if @get('justAdded')
    return true if @get('isSubmitted')
    false
  ).property('justAdded')

  showSaveButton: (->
    return false if @get('justAdded')

    @get('isNew')
  ).property('justAdded')

  showSuccessMessage: (->
    @get('justAdded') is true
  ).property('justAdded')

  showComments: (->
    return false if @get('justAdded')
    return false if @get('isNew')
    true
  ).property('isNew', 'justAdded')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    @set 'isExpanded', false
    @set 'justAdded', true
    @set 'showOptions', false

    Ember.run.later(( =>
      @set 'justAdded', false
      @set 'isSubmitted', false
      @set 'showOptions', true
      @set 'isExpanded', true
      @set 'text', null

      @get('model').commit()
      @get('content').reset()

      @trigger 'formReset'
    ), 1200)
