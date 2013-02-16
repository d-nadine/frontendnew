Radium.FormsDiscussionController = Ember.ObjectController.extend
  isDisabled: (->
    @get('justAdded') is true
  ).property('justAdded')

  showSaveButton: (->
    @get('justAdded') is false
  ).property('justAdded')

  showSuccessMessage: (->
    @get('justAdded') is true
  ).property('justAdded')
