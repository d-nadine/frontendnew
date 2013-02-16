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
