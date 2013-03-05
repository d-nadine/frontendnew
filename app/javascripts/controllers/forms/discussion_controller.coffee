Radium.FormsDiscussionController = Ember.ObjectController.extend
  isDisabled: (->
    @get('justAdded') is true
  ).property('justAdded')

  showSaveButton: (->
    return false if @get('justAdded')

    @get('isNew')
  ).property('justAdded')

  showSuccessMessage: (->
    @get('justAdded') is true
  ).property('justAdded')

  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    @set 'isExpanded', false
    @set 'justAdded', true
    @set 'showOptions', false

    if @get('isNew')
      discussion = Radium.Discussion.createRecord @get('data')

    @get('store').commit()

    setTimeout( ( =>
      @set 'justAdded', false
      @set 'isSubmitted', false
      @set 'showOptions', true
      @set 'isExpanded', true
      @set 'text', null
    ), 1500)


