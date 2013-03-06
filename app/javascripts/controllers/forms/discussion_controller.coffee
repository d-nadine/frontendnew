Radium.FormsDiscussionController = Ember.ObjectController.extend Ember.Evented,
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

  showComments: (->
    return false if @get('justAdded')
    return false if @get('isNew')
    true
  ).property('isNew', 'justAdded')


  submit: ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    isNew = @get('isNew')

    @set 'isExpanded', false
    @set 'justAdded', true
    @set 'showOptions', false

    if isNew
      discussion = Radium.Discussion.createRecord @get('data')

    @get('store').commit()

    Ember.run.later( ( =>
      @set 'justAdded', false
      @set 'isSubmitted', false
      @set 'showOptions', true
      @set 'isExpanded', true
      @set 'text', null

      @trigger 'discussionUpdated'
    ), 1500)


