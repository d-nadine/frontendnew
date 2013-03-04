Radium.FormsDiscussionController = Ember.ObjectController.extend
  isDisabled: (->
    @get('justAdded') is true
  ).property('justAdded')

  showSaveButton: (->
    return false if @get('justAdded') is false
    @get 'isNew'
  ).property('justAdded')

  showSuccessMessage: (->
    @get('justAdded') is true
  ).property('justAdded')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    unless @get('isNew')
      @get('content.transaction').commit()
      return

    discussion = Radium.Discussion.createRecord @get('data')

    discussion.get('transaction').commit()
